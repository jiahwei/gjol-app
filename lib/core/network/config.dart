import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

@Openapi(
  additionalProperties: DioProperties(
    pubName: 'my_api',
    pubAuthor: 'jing bei',
  ),
  inputSpec: RemoteSpec(path: 'http://127.0.0.1:8000/openapi.json'),
  generatorName: Generator.dio,
  outputDirectory: 'lib/core/my_api',
  runSourceGenOnOutput: true,
)
class ApiConfig {}
