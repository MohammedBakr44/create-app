#!/bin/bash

# I don't know what does this function do yet, I Just copied it from stack overflow but it does the work.
function argv {
    for a in ${BASH_ARGV[*]} ; do
      echo -n "$a "
    done
    echo
}

# Storing gulp package.json for usablity and readablity 

function createSrc {
  mkdir src && cd src

  touch index.pug style.scss main.ts

  mkdir shared && cd shared && mkdir pug scss ts

  cd pug && mkdir components && cd ..

  cd scss && mkdir abstract base components layout pages

  cd abstract && touch _functions.scss _mixins.scss _variables.scss && cd ..

  cd base && touch _animations.scss _base.scss _typography.scss _utilities.scss && cd ..

  cd .. && cd ts

  mkdir modules && cd ..
  cd ..
}

function createGulpConfig {
  cd ..
  
  touch gulpfile.js

  echo "'use strict';

const {
    task,
    parallel,
    series,
    watch,
    src,
    dest
} = require('gulp');
const sass = require('gulp-sass');
sass.compiler = require('node-sass');
const pug = require('gulp-pug');
const ts = require('gulp-typescript');
const del = require('del');

const tsProject = ts.createProject('tsconfig.json');

const files = ['./src/*.scss', './src/*.pug', './src/ts/*.ts', './src/shared/scss/*.scss', './src/shared/pug/*.pug', './src/ts/modules/*.ts'];

task('sass', () => {
    return src('./src/*.scss')
        .pipe(sass().on('error', sass.logError))
        .pipe(dest('./dist/'));
});

task('pug', () => {
    return src('./src/*.pug')
        .pipe(pug({
            pretty: true
        }))
        .pipe(dest('./dist/'))
})

task('ts', () => {
    return tsProject.src()
        .pipe(tsProject())
        .js.pipe(dest('./dist/js/'));
})

task('clean', () => {
    return del([
        './dist/css/style.css',
        '/dist/index.html'
    ]);
});


task('watch', () => {
    watch(files,
        series(['sass', 'pug']));
});" >> gulpfile.js
}

function gulp {

  echo '{
    "name": "'$1'",
    "version": "1.0.0",
    "description": "",
    "main": "index.js",
    "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1"
    },
    "keywords": [],
    "author": "",
    "license": "ISC",
    "dependencies": {
      "@babel/plugin-transform-modules-commonjs": "^7.5.0",
      "@types/gulp": "^4.0.6",
      "@types/gulp-sass": "^4.0.0",
      "@types/node": "^12.6.2",
      "common-js": "^0.3.8",
      "gulp-pug": "^4.0.1"
    },
    "devDependencies": {
      "@babel/cli": "^7.5.5",
      "@babel/core": "^7.5.5",
      "chokidar": "^3.0.2",
      "del": "^5.0.0",
      "gulp": "^4.0.2",
      "gulp-sass": "^4.0.2",
      "gulp-typescript": "^5.0.1",
      "live-server": "^1.2.1",
      "systemjs": "^5.0.0",
      "ts-node": "^8.3.0",
      "typescript": "^3.5.3"
    }
  }' >> package.json

  createSrc

  createGulpConfig


}

# Same as pervious one but for parcel, More will come soon :D. 

function parcel {
  
  echo '{
    "name": "'$1'",
    "version": "1.0.0",
    "description": "",
    "main": "index.js",
    "scripts": {
      "test": "echo \"Error: no test specified\" && exit 1",
      "dev": "parcel dev index.pug",
      "build": "parcel build index.pug"
    },
    "keywords": [],
    "author": "",
    "license": "ISC",
    "dependencies" : {
      "node-sass": "^4.12.0",
      "pug": "^2.0.4",
      "pug-cli": "^1.0.0-alpha6",
      "ts-node": "^8.3.0",
      "typescript": "^3.5.3"
    },
    "devDependencies": {
      "parcel-bundler": "^1.12.3"
    }
  }' >> package.json

  createSrc
}

function main {
  # creates project directory and change into it.

  #PS: this effect ends with last line of the script so you need to 'cd' in your projcet

  mkdir $1 && cd $1


  $2 init -y

  > package.json

  if [ "$3" == "gulp" ]; then 
    gulp $1
  elif [ "$3" == "parcel" ]; then
    parcel $1
  fi  



  if [[ "$4" == "offline"  && "$2" == "yarn" ]]; then
    $2 install --offline
  else
    $2 install
  fi   
}

if [ "$1" == "-h" ]; then
  echo "This script is for creating a project using gulp OR Parcel. Both supported now more will be added soon:D"
  echo "to use the script just type create-app followed by name of the app, package-manage(yarn/npm), bundler(gulp/parcel)
  Example: create-app myapp yarn gulp"
else 
  main $1 $2 $3 $4
fi  
