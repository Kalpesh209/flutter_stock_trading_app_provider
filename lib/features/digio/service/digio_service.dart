import 'package:kyc_workflow/environment.dart';
import 'package:kyc_workflow/kyc_workflow.dart';
import 'package:kyc_workflow/digio_config.dart';
import 'package:kyc_workflow/workflow_response.dart';

class DigioService {
  late final KycWorkflow kycWorkflow;

  DigioService() {
    final DigioConfig digioConfig = DigioConfig();
    digioConfig.environment = Environment.SANDBOX;
    kycWorkflow = KycWorkflow(digioConfig);
  }

  Future<WorkflowResponse> startKyc({
    required String documentId,
    required String identifier,
    required String tokenId,
  }) async {
    return await kycWorkflow.start(documentId, identifier, tokenId, null);
  }
}
