import com.amazonaws.services.lambda.runtime.Context;

import com.amazonaws.services.lambda.runtime.RequestStreamHandler;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;

public class Lambda implements RequestStreamHandler {

    public void handleRequest(InputStream inputStream, OutputStream outputStream, Context context) {
        try (OutputStreamWriter writer = new OutputStreamWriter(outputStream, "UTF-8")){
            writer.write("{\"headers\": {\"content-type\": \"text/html\"},\"isBase64Encoded\": false,\"body\": \"Hello Java World\",\"statusCode\": 200}");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}