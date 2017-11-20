package br.com.buzatof.imageProcess.service;

import java.awt.image.BufferedImage;
import java.awt.image.ConvolveOp;
import java.awt.image.Kernel;
import java.io.IOException;
import java.util.regex.Pattern;

import javax.imageio.ImageIO;

import org.springframework.stereotype.Service;

import com.mongodb.gridfs.GridFSDBFile;

@Service
public class ImageProcessService implements ImageProcessServiceInterface {

	int MAX_KERNEL_LENGTH = 31;
	int DELAY_BLUR = 100;


	@Override
	public BufferedImage blur(GridFSDBFile file) throws IOException {
		
		BufferedImage image = ImageIO.read(file.getInputStream());
		
		image = getGaussianBlurFilter(4, true).filter(image, null);
		image = getGaussianBlurFilter(2, false).filter(image, null);
		
		return image;

	}
	
	@Override
	public String renameFileToBlur(String fileName) {
		String[] strs = fileName.split(Pattern.quote("."));
		String nomeArquivoOrig = strs[0];
		String extArquivo = strs[1];

		String novoNome = nomeArquivoOrig + "_blur." + extArquivo;

		return novoNome;
	}	

	private static ConvolveOp getGaussianBlurFilter(int radius, boolean horizontal) {
		if (radius < 1) {
			throw new IllegalArgumentException("Radius must be >= 1");
		}

		int size = radius * 2 + 1;
		float[] data = new float[size];

		float sigma = radius / 3.0f;
		float twoSigmaSquare = 2.0f * sigma * sigma;
		float sigmaRoot = (float) Math.sqrt(twoSigmaSquare * Math.PI);
		float total = 0.0f;

		for (int i = -radius; i <= radius; i++) {
			float distance = i * i;
			int index = i + radius;
			data[index] = (float) Math.exp(-distance / twoSigmaSquare) / sigmaRoot;
			total += data[index];
		}

		for (int i = 0; i < data.length; i++) {
			data[i] /= total;
		}

		Kernel kernel = null;
		if (horizontal) {
			kernel = new Kernel(size, 1, data);
		} else {
			kernel = new Kernel(1, size, data);
		}
		return new ConvolveOp(kernel, ConvolveOp.EDGE_NO_OP, null);
	}


	

	/*
	 * private static Mat readInputStreamIntoMat(InputStream inputStream,int length)
	 * throws IOException { // Read into byte-array byte[] temporaryImageInMemory =
	 * readStream(inputStream, length);
	 * 
	 * // Decode into mat. Use any IMREAD_ option that describes your image
	 * appropriately Mat outputImage = Imgcodecs.imdecode(new
	 * MatOfByte(temporaryImageInMemory), Imgcodecs.IMREAD_COLOR);
	 * 
	 * return outputImage; }
	 * 
	 * private static InputStream readMatIntoInputStream(Mat dst)throws IOException
	 * {
	 * 
	 * MatOfByte mob=new MatOfByte(); Imgcodecs.imencode(".jpg", dst, mob); byte
	 * ba[]=mob.toArray();
	 * 
	 * BufferedImage bi=ImageIO.read(new ByteArrayInputStream(ba));
	 * 
	 * ByteArrayOutputStream os = new ByteArrayOutputStream(); ImageIO.write(bi,
	 * "jpg", os); InputStream is = new ByteArrayInputStream(os.toByteArray());
	 * 
	 * return is;
	 * 
	 * 
	 * }
	 * 
	 * private static byte[] readStream(InputStream stream, int length) throws
	 * IOException { // Copy content of the image to byte-array
	 * ByteArrayOutputStream buffer = new ByteArrayOutputStream(); int nRead; byte[]
	 * data = new byte[length];
	 * 
	 * while ((nRead = stream.read(data, 0, data.length)) != -1) {
	 * buffer.write(data, 0, nRead); }
	 * 
	 * buffer.flush(); byte[] temporaryImageInMemory = buffer.toByteArray();
	 * buffer.close(); stream.close(); return temporaryImageInMemory; }
	 */

}
