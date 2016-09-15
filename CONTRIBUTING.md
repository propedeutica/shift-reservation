**Welcome!**

Contributions are accepted and welcome in any part of the application.

*If you want to contribute to this project:*

Clone the project into your own and create a branch with your changes. Pull request will be reviewed as soon as we can.

You can also open issues in the project, the list of enhancements and bugs is in the same list so feel free to add both:
Issues list: [Issues and RFE](https://github.com/propedeutica/shift-reservation/issues)
Opening issues will allows us to write better code and make sure it is more usable.

If you wish to contribute with a translation of the project in your language, we are of course happy to accept them.

All pull request need to pass some tests before they are merged. You can find a list of tests in travis-ci.org.
You can also run the same tests locally to make sure that PR can be accepted.

- You can run the following test from the root directory of the repository:
```bash
    $ bundle exec rspec              # It shouldn't give failures
    $ rubocop                        # It shouldn't give offenses
    $ haml-lint app/views/           # It shouldn't print nothing
```

**Thanks for your contribution!**

## License

This project has been created with a double license so you can create your fork using one of them or both:

See [Apache license](LICENSE.md)
See [AGPL License](LICENSE-AGPL.md)

If you create your own project from this one, we will be happy if you choose only one, and we would be happier if you use AGPL. The main reason to allow for two is that you can integrate parts of code into any MIT or Apache project without worrying about implications.
