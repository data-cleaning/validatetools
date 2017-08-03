# TODO

- implement `make_feasible`: needs an updated version of errorlocate to support soft rules
- add `decorate_validator`: add metadata to the simplified versions of the validator objects, with the correct
`origin`, `created` and possibly and updated description (e.g. `simplified version of: `)
- `is_contradicted_by`: find out for a rule which other rules are contradictory, subtleties: those sets should not share rules. 
- `is_implied_by`: find out for a rule which other rules imply this rule.
- add an argument to `detect_redundancy` to return the same rules as `simplify_redundancy`.

