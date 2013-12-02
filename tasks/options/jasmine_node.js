/**
 * Created by randall on 12/1/13.
 */
module.exports = {
  forceExit: true,
  match: '.',
  matchall: false,
  extensions: 'js|coffee',
  useCoffee: true,
  specNameMatcher: 'spec',
  jUnit: {
    report: false,
    savePath : "./build/reports/jasmine/",
    useDotNotation: true,
    consolidate: true
  }
};
