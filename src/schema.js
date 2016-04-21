import packageJSON from '../package.json';
const currentVersion = packageJSON.version;
const messageSchemas = [
  {
    "id": "/CreateResource",
    "title": "Create Resource",
    "type": "object",
    "properties": {
      "lbvserver": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "serviceType": {
            "type": "string"
          }
        }
      }
    }
  }
];

const configureSchema = {
	"title": "Netscaler Info",
	"type": "object",
	"properties": {
		"username": {
			"type": "string",
      "minLength": 1
		},
		"password": {
			"type": "string",
      "minLength": 1
		},
    "hostAddress": {
      "type": "string",
      "minLength": 1
    }
	},
	"required": ["username", "password", "hostAddress"]
};

export const Schemas = {
 messageSchemas,
  version: "1.0.0",
  configureSchema
};
