const path = require('path');
const esbuild = require('esbuild');

out_base = "src"
out_dir = "dist/src"

const entryPoints = [ "src/lambda/serverless.ts"]

esbuild.build({
    entryPoints, 
    bundle: true,
    outdir: path.join(__dirname, outDir),
    outbase: functionsDir,
    platform: 'node',
    sourcemap: 'inline',
    loader: { ".node": "file" }
})