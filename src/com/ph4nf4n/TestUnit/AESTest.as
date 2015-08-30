package com.ph4nf4n.TestUnit
{
	import com.hurlant.crypto.prng.Random;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
	import com.ph4nf4n.core.AES;
	
	
	public class AESTest
	{
		private static const RAND:Random = new Random();
		private var aes:AES;
		private var key:ByteArray;
		private var iv:ByteArray;
		private var text:ByteArray;
		
		public function AESTest()
		{
			key = AES.generateKey(AES.DEFAULT_CIPHER_NAME);
			iv = AES.generateIV(AES.DEFAULT_CIPHER_NAME, key);
			aes = new AES(key, iv);
			
			text = new ByteArray();
			//RAND.nextBytes(text, 32);
			var str:String = "123456";
			text = aes.convertStringToByteArray(str);
			
			var encryptedBytes:ByteArray = aes.encrypt(text);
			
			trace("原文是（str）：" + str);
			trace("原文是（Hex）：" + Hex.fromArray(text));
			trace("加密后（Hex）：" + Hex.fromArray(encryptedBytes));
			
			var decryptedBytes:ByteArray = aes.decrypt(encryptedBytes);
			
			trace("解密后（Hex）：" + Hex.fromArray(decryptedBytes));
			
		}
	}
}