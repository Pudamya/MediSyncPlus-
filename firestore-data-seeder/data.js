const hospitalsData = [
  {
    hospitalId: "hosp_004",
    name: "Metro Health Central",
    address: { street: "101 Health Way", city: "Metrocity", state: "CA"},
    phoneNumber: "+1-555-101-0001",
    email: "info@metrohealth.org",
    type: "General Hospital",
    departments: ["Cardiology", "Emergency", "Neurology", "Pediatrics"]
  },
  {
    hospitalId: "hosp_005",
    name: "Green Valley Clinic",
    address: { street: "202 Nature Rd", city: "Greenvalley", state: "OR" },
    phoneNumber: "+1-555-202-0002",
    email: "contact@greenvalleyclinic.com",
    type: "Community Clinic",
    departments: ["Family Medicine", "Wellness", "Minor Procedures"]
  },
  {
    hospitalId: "hosp_006",
    name: "Children's Joy Hospital",
    address: { street: "303 Playful Ave", city: "Sunnytown", state: "FL"},
    phoneNumber: "+1-555-303-0003",
    email: "care@childrensjoy.org",
    type: "Children's Hospital",
    departments: ["Pediatrics", "Neonatology", "Child Development"]
  },
  {
    hospitalId: "hosp_007",
    name: "University Medical Center",
    address: { street: "404 Scholars Dr", city: "Academiaton", state: "MA"},
    phoneNumber: "+1-555-404-0004",
    email: "admin@umc.edu",
    type: "Teaching Hospital",
    departments: ["Internal Medicine", "Surgery", "Research", "Oncology"]
  }
];

const doctorsData = [
  {
    doctorId: "doc_002",
    firstName: "Alice",
    lastName: "Wonder",
    fullName: "Dr. Alice Wonder",
    address: { street: "10 Medical Plaza", city: "Metrocity", state: "CA", zipCode: "90001", country: "USA" },
    phoneNumber: "+1-555-001-1001",
    nic: "WNDA010180X",
    email: "alice.wonder@email.com",
    specializations: ["Cardiology"],
    affiliatedHospitals: [{ hospitalId: "hosp_004", hospitalName: "Metro Health Central", department: "Cardiology" }],
    education: [{ degree: "MD", institution: "Metrocity University", year: "2005" }],
    registrationNo: "MEDCA001W",
    profileImageUrl: "https://example.com/images/alice.jpg",
    bio: "Cardiologist passionate about preventative care.",
    
  },
  {
    doctorId: "doc_002",
    firstName: "Bob",
    lastName: "Builder",
    fullName: "Dr. Bob Builder",
    address: { street: "20 Clinic Court", city: "Greenvalley", state: "OR", zipCode: "97002", country: "USA" },
    phoneNumber: "+1-555-002-2002",
    nic: "BLDB020275Y",
    email: "bob.builder@email.com",
    specializations: ["Family Medicine"],
    affiliatedHospitals: [{ hospitalId: "hosp_005", hospitalName: "Green Valley Clinic", department: "Family Medicine" }],
    education: [{ degree: "DO", institution: "Greenvalley Medical School", year: "2008" }],
    registrationNo: "MEDOR002B",
    profileImageUrl: "https://example.com/images/bob.jpg",
    bio: "Your friendly neighborhood family doctor.",
   
  },
  {
    doctorId: "doc_003",
    firstName: "Charlie",
    lastName: "Brown",
    fullName: "Dr. Charlie Brown",
    address: { street: "30 Sunshine Lane", city: "Sunnytown", state: "FL", zipCode: "33003", country: "USA" },
    phoneNumber: "+1-555-003-3003",
    nic: "BRNC030382Z",
    email: "charlie.brown@email.com",
    specializations: ["Pediatrics"],
    affiliatedHospitals: [{ hospitalId: "hosp_006", hospitalName: "Children's Joy Hospital", department: "Pediatrics" }],
    education: [{ degree: "MD", institution: "Sunnytown Medical College", year: "2010" }],
    registrationNo: "MEDFL003C",
    profileImageUrl: "https://example.com/images/charlie.jpg",
    bio: "Making little ones smile and stay healthy.",
    
  },
  {
    doctorId: "doc_004",
    firstName: "Diana",
    lastName: "Prince",
    fullName: "Dr. Diana Prince",
    address: { street: "40 Wisdom Way", city: "Academiaton", state: "MA", zipCode: "02004", country: "USA" },
    phoneNumber: "+1-555-004-4004",
    nic: "PRND040478A",
    email: "diana.prince@email.com",
    specializations: ["Internal Medicine", "Oncology"],
    affiliatedHospitals: [{ hospitalId: "hosp_007", hospitalName: "University Medical Center", department: "Oncology" }],
    education: [{ degree: "MD, PhD", institution: "Academiaton University", year: "2003" }],
    registrationNo: "MEDMA004P",
    profileImageUrl: "https://example.com/images/diana.jpg",
    bio: "Dedicated to comprehensive adult care and cancer treatment.",
   
  },
  {
    doctorId: "doc_005",
    firstName: "Edward",
    lastName: "Scissorhands",
    fullName: "Dr. Edward Scissorhands",
    address: { street: "50 Creative Cut", city: "Metrocity", state: "CA", zipCode: "90001", country: "USA" },
    phoneNumber: "+1-555-005-5005",
    nic: "SCSE050585B",
    email: "edward.s@email.com",
    specializations: ["Surgery", "Dermatology"], // A bit of fun here
    affiliatedHospitals: [
        { hospitalId: "hosp_001", hospitalName: "Metro Health Central", department: "Surgery" },
        { hospitalId: "hosp_007", hospitalName: "University Medical Center", department: "Dermatology" }
    ],
    education: [{ degree: "MD", institution: "Unique Medical Institute", year: "2000" }],
    registrationNo: "MEDCA005S",
    profileImageUrl: "https://example.com/images/edward.jpg",
    bio: "Precision and care in every procedure.",
  
  }
];

module.exports = { hospitalsData, doctorsData };