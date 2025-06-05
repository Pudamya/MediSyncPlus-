// seed.js

const admin = require('firebase-admin');
const { hospitalsData, doctorsData } = require('./data.js'); // Import data

// --- IMPORTANT: Path to your service account key JSON file ---
// Make sure this path is correct and the file exists in your project root
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// Function to generate example availability slots
function generateAvailabilitySlots(doctor) {
  const slots = [];
  const today = new Date();
  const numberOfSlotsToGenerate = 5; // Generate 5 slots per doctor

  for (let i = 0; i < numberOfSlotsToGenerate; i++) {
    // Stagger start times for variety, e.g., next few days
    const slotDate = new Date(today);
    slotDate.setDate(today.getDate() + i); // Slots on different days
    slotDate.setHours(9 + (i % 3), (i % 2) * 30, 0, 0); // 9:00, 10:30, 11:00 etc.

    const startTime = new Date(slotDate);
    const endTime = new Date(startTime);
    endTime.setMinutes(startTime.getMinutes() + 30); // 30-minute slots

    // Determine hospitalId for the slot based on doctor's first affiliation
    const hospitalAffiliation = doctor.affiliatedHospitals && doctor.affiliatedHospitals.length > 0
                                ? doctor.affiliatedHospitals[0]
                                : null;

    slots.push({
      startTime: admin.firestore.Timestamp.fromDate(startTime),
      endTime: admin.firestore.Timestamp.fromDate(endTime),
      durationMinutes: 30,
      isBooked: false,
      bookedByPatientId: null,
      appointmentId: null,
      hospitalId: hospitalAffiliation ? hospitalAffiliation.hospitalId : null,
      hospitalName: hospitalAffiliation ? hospitalAffiliation.hospitalName : "N/A (No Affiliation)" // Denormalize for convenience
    });
  }
  return slots;
}


async function seedDatabase() {
  console.log("Starting to seed database...");

  // --- Seed Hospitals ---
  console.log("\n--- Seeding Hospitals ---");
  const hospitalsCollection = db.collection('hospitals');
  for (const hospital of hospitalsData) {
    try {
      await hospitalsCollection.doc(hospital.hospitalId).set(hospital);
      console.log(`Hospital Added/Updated: ${hospital.name} (ID: ${hospital.hospitalId})`);
    } catch (error) {
      console.error(`Error adding hospital ${hospital.name}: `, error);
    }
  }
  console.log("Hospitals seeding complete.");

  // --- Seed Doctors ---
  console.log("\n--- Seeding Doctors ---");
  const doctorsCollection = db.collection('doctors');
  for (const doctor of doctorsData) {
    try {
      // Separate the main doctor data from any slot generation logic
      const doctorInfo = { ...doctor }; // Shallow copy
      // delete doctorInfo.bookingSlotsSchemaNote; // Or keep it, depends on your preference

      await doctorsCollection.doc(doctor.doctorId).set(doctorInfo);
      console.log(`Doctor Added/Updated: ${doctor.fullName} (ID: ${doctor.doctorId})`);

      // --- Seed Availability Slots for this Doctor (Subcollection) ---
      const availabilitySlots = generateAvailabilitySlots(doctor);
      const slotsSubcollection = doctorsCollection.doc(doctor.doctorId).collection('availabilitySlots');

      console.log(`  Adding ${availabilitySlots.length} availability slots for ${doctor.fullName}...`);
      for (const slot of availabilitySlots) {
        // .add() will auto-generate a unique ID for each slot document
        const slotRef = await slotsSubcollection.add(slot);
        // console.log(`    Added slot ID: ${slotRef.id} at ${slot.startTime.toDate().toLocaleString()}`);
      }
      console.log(`  Finished adding slots for ${doctor.fullName}.`);

    } catch (error) {
      console.error(`Error adding doctor ${doctor.fullName} or their slots: `, error);
    }
  }
  console.log("Doctors and their availability slots seeding complete.");

  console.log("\nDatabase seeding finished!");
}

seedDatabase()
  .then(() => {
    console.log("Script executed successfully.");
    process.exit(0); // Exit cleanly
  })
  .catch(error => {
    console.error("Unhandled error in seedDatabase:", error);
    process.exit(1); // Exit with error code
  });