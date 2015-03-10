Dental Data
============

Anonymized data from a dental office on regular visitors.

Data Normalization Notes
=========================
- Removed duplicate field `patient_id`
- Removed `name`
  - name data was anonymized to just be "Patient {{patient_id}}" so
    it didn't provide much value. Just repeated the `patient_id`.
- Removed `has_address_1`
  - doesn't matter since we don't have exact street
    addresses
- Fixed `city`.
  - Lots of misspellings like "St. Paul" vs. "St Paul" vs "St.Paul".
    Used SQL GROUP BY to evaluate differences in city spellings and update
    accordingly
- Fixed dates to be SQL-compliant formatted.
- Normalized `zipcode` by simplifying 9-digit zip codes to 5-digit zip codes.
- Removed patient 2738 due to bad data ('68' for `state` and '801' for 
  `zipcode`...)
- Renamed some columns for clarity
- Created SQL and JSON representations of the data