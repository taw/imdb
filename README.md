Collection of tools for downloading and converting imdb database.

The data is meant for personal and non-commercial use only.
See http://www.imdb.com/interfaces for details.

To download imdb database:

    rake download

To export everything to csv:

    rake export:csv

Note that the process takes quite a while (about 30 minutes on a good laptop), and files are fairly big (7.5GB for sources, and 6.5GB for generated CSV).

# Supported tables
- [x] actors
- [x] actresses
- [ ] aka-names
- [ ] aka-titles
- [ ] alternate-versions
- [ ] biographies
- [ ] business
- [x] certificates
- [x] cinematographers
- [x] color-info
- [x] complete-cast
- [x] complete-crew
- [x] composers
- [x] costume-designers
- [x] countries
- [ ] crazy-credits
- [x] directors
- [x] distributors
- [x] editors
- [x] genres
- [ ] german-aka-titles
- [ ] goofs
- [x] keywords
- [x] language
- [ ] laserdisc
- [ ] literature
- [x] locations
- [x] miscellaneous-companies
- [x] miscellaneous
- [ ] movie-links
- [x] movies
- [ ] mpaa-ratings-reasons
- [ ] plot
- [x] producers
- [x] production-companies
- [x] production-designers
- [ ] quotes
- [x] ratings
- [x] release-dates
- [x] running-times
- [x] sound-mix
- [ ] soundtracks
- [x] special-effects-companies
- [ ] taglines
- [x] technical
- [ ] trivia
- [x] writers
