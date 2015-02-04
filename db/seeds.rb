rok = User.create(email: 'rok@example.com', password: 'test1234')
mat = User.create(email: 'mat@example.com', password: 'test1234')

rok_response_1 = Response.create(user: rok, content: 'You father smells of elderberries!')
mat_response_to_1 = Response.create(user: mat, content: 'Yeah, well yours still believes in tooth-ferries!', parent_response: rok_response_1)

mat_response_2 = Response.create(user: mat, content: 'Nice weather today, is it not?')
rok_response_to_2 = Response.create(user: rok, content: 'Your face is weather.', parent_response: mat_response_2)

mat.opinions.create(response: rok_response_1, value: false)
rok.opinions.create(response: mat_response_to_1, value: true)