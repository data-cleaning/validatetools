# TODO

- add `decorate_validator`: add metadata to the simplified versions of the validator objects, with the correct
`origin`, `created` and possibly and updated description (e.g. `simplified version of: `)
- add an argument to `detect_redundancy` to return the same rules as `simplify_redundancy`.

- rearrange parts of validatetools and errorlocate (only exported functions used).


# Rescaling of rule matrix

- Use data to determine a (sub) optimal scaling of the MIP matrix: ideally the entries of the matrix should have the same order (~1).
