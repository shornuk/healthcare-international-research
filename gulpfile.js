// Gulp with Tailwindcss for Craftcms
// 1. npm run dev // To start development and server for live preview
// 2. npm run build // To generate minifed files for live server

const { src, dest, task, watch, series, parallel } = require('gulp');
const options = require("./package.json").options; // Options : paths and other options from package.json
const browserSync = require('browser-sync').create();
const concat = require('gulp-concat'); // For Concatinating js,css files
const postcss = require('gulp-postcss'); // For Compiling tailwind utilities with tailwind config
const cssimport = require('postcss-import'); // For importing css files
const log = require('fancy-log'); // For Console logs
const size = require('gulp-size'); // For reporting size of files
const cssnano = require('cssnano'); // To Minify CSS files
const rename = require('gulp-rename'); // For adding min suffix
const replace = require('gulp-replace'); // For adding min suffix
const tailwindcss = require('tailwindcss');
const svgo = require('gulp-svgo'); // For optimising the svg files
const autoprefixer = require('autoprefixer'); // Browser compatibility

// Load Previews on Browser on dev
task('livepreview', (done) => {
    browserSync.init({
        notify: false,
        proxy: options.config.local,
        https: true,
        port: 3000
    });
    done();
});

// Compiling styles
task('dev-css', ()=> {
    return src(options.paths.src.css + '/app.css')
        .pipe(postcss([
            cssimport(),
            tailwindcss(options.config.tailwindjs),
            autoprefixer()
        ]))
        .pipe(concat({ path: 'app.css'}))
        .pipe(dest(options.paths.dist.css));
});

// Compiling styles
task('build-css', ()=> {
    return src(options.paths.dist.css + '/app.css')
        .pipe(postcss([
            cssnano()
        ]))
        .pipe(rename({suffix: '.min'}))
        .pipe(size({ gzip: true, showFiles: true }))
        .pipe(dest(options.paths.dist.css));
});

// Copies & minifies image files to build
task('build-img', (done) =>{
    src(options.paths.src.img + '/**/*')
        .pipe(dest(options.paths.dist.img));
        done();
});

// Copies & optimises SVG files to build
task('build-svg', (done) =>{
    src(options.paths.src.svg + '/**/*')
        .pipe(svgo({
            multipass: true,
            plugins: [
                { removeDimensions: true },
                { removeAttrs: {
                    attrs: ['fill']
                }}
            ]
        }))
        .pipe(dest(options.paths.dist.svg));
        done();
});

// Copies font files/folders to build
task('build-fonts', (done) =>{
    src(options.paths.src.fonts + '/**/*')
        .pipe(dest(options.paths.dist.fonts));
        done();
});

// Watch files for changes
task('watch', (done) => {
    log("-> Watching for changes");
    watch(options.config.tailwindjs,series('dev-css',reload));
    watch(options.paths.templates,series('dev-css',reload));
    watch(options.paths.src.css+'/**/*',series('dev-css',reload));
    watch(options.paths.src.img+'/**/*',series('build-img',reload));
    watch(options.paths.src.svg+'/**/*',series('build-svg',reload));
    done();
});

function reload(done){
    log("-> Reloading Preview");
    browserSync.reload();
    done();
}

// series of tasks to run on dev command
task('development', series('dev-css', (done)=>{
    done();
    log("-> Development started");
}));

task('production', series('dev-css','build-css', 'build-img', 'build-fonts',(done)=>{
    done();
    log("-> Build Complete");
}));

exports.default = series('development','livepreview','watch');
exports.build = series('production');
