const path = require('path');
const esbuild = require('esbuild');

out_base = ""
out_dir = ""

const entryPoints = [ "", ""]

esbuild.build({
    entryPoints,
    bundle: true,
    outdir: out_dir,
    outbase: out_base,
    platform: 'node',
    sourcemap: 'inline',
    loader: { ".node": "file" },
})