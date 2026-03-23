# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create five example Officer records. Uses `find_or_create_by!` so running seeds is idempotent.
officers = [
  {
    name: "Aisha Thompson",
    bn: "BN-1001",
    incident: "Responded to a two-vehicle collision on Elm St; assisted with traffic control and collected witness statements."
  },
  {
    name: "Marcus Lee",
    bn: "BN-1002",
    incident: "Conducted a welfare check that resulted in referral to social services for a vulnerable adult."
  },
  {
    name: "Rita Alvarez",
    bn: "BN-1003",
    incident: "Took an anonymous tip leading to the recovery of stolen property and identification of suspects."
  },
  {
    name: "Ethan Murphy",
    bn: "BN-1004",
    incident: "Patrolled downtown during evening shift; de-escalated an altercation and filed a report."
  },
  {
    name: "Linda Park",
    bn: "BN-1005",
    incident: "Assisted with a missing person case; coordinated with search teams and updated family."
  }
]

officers.each do |attrs|
  Officer.find_or_create_by!(bn: attrs[:bn]) do |o|
    o.name = attrs[:name]
    o.incident = attrs[:incident]
  end
end
