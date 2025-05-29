import { setOutput, setFailed } from '@actions/core'; // GitHub Actions toolkit for inputs/outputs
import github from '@actions/github'; // GitHub context object

try {
  // Get the issue body input from the action.yml definition
  const body = process.argv[2];
  const title = process.argv[3];

  // --- Start Parsing Logic ---
  let app = '';
  let version = '';

  // Assuming the format is: "anything app_name version_number anything_else"
  // and you want the second and third space-separated words.
  // This is a simple split, for more complex patterns, use regex.

  const words = body.split(' '); // Split by space

  if (words.length >= 2) {
    app = words[1]; // Second word (index 1)
  }
  if (words.length >= 3) {
    version = words[2]; // Third word (index 2)
  }

  // --- Sanitize the Extracted Values (Crucial for downstream use!) ---
  // Even though JavaScript parsing is safe, if these values are later
  // used in a shell command (e.g., in a subsequent Bash step),
  // they could still introduce injection if not sanitized.
  // A common sanitization is to allow only alphanumeric, dots, and hyphens.
  // Adjust the regex `[^a-zA-Z0-9.\-_]` based on what characters are valid for your app/version names.

  app = app.replace(/[^a-zA-Z0-9.\-_]/g, '');
  version = version.replace(/[^a-zA-Z0-9.\-_]/g, '');

  let appFromTitle = '';
  const titleRegex = /^【Auto-build】(.*)/;
  const match = title.match(titleRegex);
    if (match && match[1]) {
    appFromTitle = match[1].trim(); // Get the captured group and trim whitespace
  }

    // Sanitize the extracted app name from the title
  // Crucial as this will be compared and potentially used downstream
  appFromTitle = appFromTitle.replace(/[^a-zA-Z0-9.\-_]/g, '');

  // --- End Parsing Logic ---

  // Set the outputs of the action
  setOutput('app', app);
  setOutput('version', version);
  setOutput('title-app', appFromTitle);

  console.log(`Extracted App: "${app}"`);
  console.log(`Extracted Version: "${version}"`);
  console.log(`Extracted App from Title: "${appFromTitle}"`);

} catch (error) {
  setFailed(error.message); // Set the action to a failed state if an error occurs
}