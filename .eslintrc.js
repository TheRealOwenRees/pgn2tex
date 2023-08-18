module.exports = {
  env: {
    browser: true,
    es2016: true,
    node: true,
    jest: true,
  },
  extends: ['airbnb-base', 'plugin:@typescript-eslint/recommended'],
  plugins: ['@typescript-eslint'],
  overrides: [
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  rules: {
    'lines-between-class-members': 'off',
  },
};
