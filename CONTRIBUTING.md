# Exprestive Developer Documentation

#### Setup the development environment
* install Node.JS
* `rm -rf node_modules ; npm install`


#### Run tests
* run all tests: `npm test`
* run unit tests: `npm run unit-tests`
* run feature tests: `npm run feature-tests`


#### Update dependencies
* check whether updates are available: `npm run update-check`
* automatically update all dependencies to the latest version: `npm run update`
* manually update individual dependencies
  * update [package.json](package.json) to the versions given by update-check
  * check that the new dependencies work

    ```
    rm -rf node_modules ; npm i
    npm test
    ```


#### Release a new version

* [update the dependencies](#update-dependencies) to the latest version

```
npm version <patch|minor|major>
npm publish
```


