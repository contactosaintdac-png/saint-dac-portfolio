const fs = require('fs');
const { Jimp, intToRGBA } = require('jimp');

async function processLogo() {
    console.log('Loading image...');
    const image = await Jimp.read('./assets/logo.jpg');
    
    const count = 20000;
    const width = 141; // Math.floor(Math.sqrt(20000))
    const imgWidth = image.bitmap.width;
    const imgHeight = image.bitmap.height;
    
    console.log(`Image loaded: ${imgWidth}x${imgHeight}`);
    
    // The WebGL space width in index.html is controlled by:
    // cx = (col - width / 2) * spacing;
    // With spacing = 1.2, it spans roughly from -84 to +84.
    // The Y coordinate in WebGL: positive is up, negative is down.
    
    let posData = [];
    let colData = [];
    
    // We want the logo to be centered at (0, 0, 0)
    // Scale the image grid to WebGL space.
    // We'll map the 141x142 grid over the image.
    
    for (let i = 0; i < count; i++) {
        const row = Math.floor(i / width); // 0 to 141
        const col = i % width; // 0 to 140
        
        // Normalize grid coordinates to 0..1
        // row=0 should map to the TOP of the image (y=0 in image space)
        // because in WebGL, we usually want it right-side up.
        // But wait, in index.html: cz = (row - width/2) * spacing.
        // Our animation in index.html moves from ocean (X/Z plane) to Logo.
        // Wait, the Logo in the original script had:
        // targetX = X, targetY = Y, targetZ = 0.
        // So the logo is on the X/Y plane!
        
        const u = col / (width - 1);
        const v = row / Math.floor(count / width); // 0 to 1
        
        // Image pixel coordinates
        const px = Math.floor(u * (imgWidth - 1));
        const py = Math.floor(v * (imgHeight - 1));
        
        const hex = image.getPixelColor(px, py);
        const rgba = intToRGBA(hex);
        const r = rgba.r / 255;
        const g = rgba.g / 255;
        const b = rgba.b / 255;
        
        // Calculate target positions for the logo
        // Map u: 0..1 -> -35..35
        // Map v: 0..1 -> 35..-35 (so top of image is +35, bottom is -35)
        const targetX = (u - 0.5) * 70;
        const targetY = (0.5 - v) * 70; 
        const targetZ = 0;
        
        // If the pixel is pure black (or very close), we hide it by sending it far away
        const isBlack = (r < 0.05 && g < 0.05 && b < 0.05);
        
        if (isBlack) {
            posData.push(targetX, -500, targetZ);
            colData.push(0, 0, 0);
        } else {
            posData.push(targetX, targetY, targetZ);
            colData.push(r, g, b);
        }
    }
    
    const outStr = `window.POS_DATA = [${posData.join(',')}];\nwindow.COL_DATA = [${colData.join(',')}];\n`;
    fs.writeFileSync('./assets/particle-data.js', outStr);
    console.log('Successfully wrote particle-data.js');
}

processLogo().catch(console.error);
