insert into movies.movie (title, year) values
  ('Double Indemnity', 1941), ('Dr. Strangelove', 1961);

insert into movies.person (firstname, lastname) values
  ('Barbara', 'Stanwyck'), ('Stanley', 'Kubrick');

insert into movies.collaborator (movie_id, person_id) values
  ((select id from movies.movie where title = 'Double Indemnity'), (select id from movies.person where firstname = 'Barbara')),
  ((select id from movies.movie where title = 'Dr. Strangelove'), (select id from movies.person where firstname = 'Stanley'));
