// @ts-check
import repoConfig from '@repo/eslint-config';
import eslintPluginPrettierRecommended from 'eslint-plugin-prettier/recommended';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  ...repoConfig,
  eslintPluginPrettierRecommended,
  {
    ignores: ['eslint.config.mjs', 'dist/**', 'src/generated/**'],
  },
  {
    rules: {
      'prettier/prettier': ['error', { endOfLine: 'auto' }],
    },
  },
);
