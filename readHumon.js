// Terminal: node readHumon.js
// https://playcode.io/

byteArrayToFloat = function(r){
	var e = r[3]<<24 | r[2]<<16 | r[1]<<8 | r[0], n = new ArrayBuffer(4); 
	return new Int32Array(n)[0] = e, new Float32Array(n)[0]
}

// b3 cb 15 42 0c 2c 89 42 06 96 25 3f 00 00 40 40
// c0 be 35 41 c2 23 b8 41 3f 3c 2b 3f 00 00 40 40 

let b_array = new Uint32Array(4);

b_array[0] = 0xb3
b_array[1] = 0xcb
b_array[2] = 0x15
b_array[3] = 0x42

let b_array1 = new Uint32Array(4);

b_array1[0] = 0x0c
b_array1[1] = 0x2c
b_array1[2] = 0x89
b_array1[3] = 0x42

let b_array2 = new Uint32Array(4);

b_array2[0] = 0x06
b_array2[1] = 0x96
b_array2[2] = 0x25
b_array2[3] = 0x3f

let b_array3 = new Uint32Array(4);

b_array3[0] = 0x00
b_array3[1] = 0x00
b_array3[2] = 0x40
b_array3[3] = 0x40

console.log({ myMessage:byteArrayToFloat(b_array) })
console.log({ myMessage:byteArrayToFloat(b_array1) })
console.log({ myMessage:byteArrayToFloat(b_array2) })
console.log({ myMessage:byteArrayToFloat(b_array3) })
