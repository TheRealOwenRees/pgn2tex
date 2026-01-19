module.exports = {
  env: {
    browser: true,
    es2016: true,
    node: true,
    jest: true,
  },
  extends: ['airbnb-base', 'plugin:@typescript-eslint/recommended'],
  plugins: ['@typescript-eslint', 'prettier'],
  overrides: [
    {
      files: ['*.ts', '*.tsx', '*.tsx'],
      rules: { 'operator-linebreak': 'off', 'import/prefer-default-export': 'off' },
    },
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  rules: {
    'prettier/prettier': 'error',
    'lines-between-class-members': 'off',
    'import/extensions': 'off',
    'import/no-unresolved': 'off',
  },
};
