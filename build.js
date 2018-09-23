"use strict";

const chokidar = require('chokidar');
const {spawnSync} = require('child_process');
const browserSync = require('browser-sync');

const config = require('./config.js');

console.log("AsciiDoctor Packt Watcher started!");

const log = console.log.bind(console);

let asciiDoctorWatcher = chokidar.watch('*.adoc', {
	ignored: config.ignoredFiles,
	//ignored: '^(?!TITLE).+', // we only care about files starting with TITLE
	persistent: true,
	ignoreInitial: false,
	ignorePermissionErrors: false
});

asciiDoctorWatcher
	.on('add', path => {
		log(`AsciiDoctor file added: ${path}`);
		//updateAssets();
		buildDoc(path);
	})
	.on('change', path => {
		log(`AsciiDoctor file changed: ${path}`);
		//updateAssets();
		buildDoc(path);
	});

function buildDoc(filename){
	log(`Building ${filename}`);
	let buildFile = spawnSync('bash', ['./build.sh', 'single_file', `${filename}`,]);
	log(`${buildFile.stderr.toString()}`);
	log(`${buildFile.stdout.toString()}`);
}

let assetsWatcher = chokidar.watch(config.assetsDir, {
	ignored: config.ignoredAssets,
	//ignored: '^(?!TITLE).+', // we only care about files starting with TITLE
	persistent: true,
	ignoreInitial: true,
	ignorePermissionErrors: false
});

assetsWatcher
	.on('all', (event, path) => { // whatever happens to the assets, we update the contents in the destination dir
		log('Asset change detected...');
		updateAssets();
	});

function updateAssets() {
	log('Updating the assets');
	let cleanAssets = spawnSync('bash', ['./build.sh', 'clean_assets']);
	//log(`${cleanAssets.stderr.toString()}`);
	//log(`${cleanAssets.stdout.toString()}`);
	let copyAssets = spawnSync('bash', ['./build.sh', 'copy_assets']);
	//log(`${copyAssets.stderr.toString()}`);
	//log(`${copyAssets.stdout.toString()}`);
	log('Assets updated');
}

// Run BrowserSync
browserSync({
    server: 'dist',
    files: [`${config.destinationDir}/*.html`, `${config.destinationDir}/assets/**.*`],
	directory: true
});
