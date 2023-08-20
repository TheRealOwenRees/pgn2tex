const { CleanWebpackPlugin } = require('clean-webpack-plugin');

const CopyWebpackPlugin = require('copy-webpack-plugin');

const path = require('path');

const isProduction = process.env.NODE_ENV == 'production';

const config = {
  entry: './src/pgn2tex.ts',
  output: {
    path: path.resolve(__dirname, 'dist'),
    chunkFilename: '[name].js',
    filename: 'pgn2tex.js',
  },
  devServer: {
    open: true,
    host: 'localhost',
  },
  devtool: 'source-map',
  plugins: [
    new CleanWebpackPlugin(),
    new CopyWebpackPlugin({
      patterns: [
        { from: './src/package.json', to: '../dist/package.json' },
        { from: './src/pgn2tex.d.ts', to: '../dist/pgn2tex.d.ts' },
      ],
    }),
  ],
  module: {
    rules: [
      {
        test: /\.(ts|tsx)$/i,
        loader: 'ts-loader',
        exclude: ['/node_modules/'],
      },
      {
        test: /\.(eot|svg|ttf|woff|woff2|png|jpg|gif)$/i,
        type: 'asset',
      },

      // Add your rules for custom modules here
      // Learn more about loaders from https://webpack.js.org/loaders/
    ],
  },
  resolve: {
    extensions: ['.tsx', '.ts', '.jsx', '.js', '...'],
  },
};

module.exports = () => {
  if (isProduction) {
    config.mode = 'production';
  } else {
    config.mode = 'development';
  }
  return config;
};