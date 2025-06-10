const { Pool } = require("pg");
const AWS = require("aws-sdk");

let pool;

async function getDBCredentialsFromSSM() {
  const ssm = new AWS.SSM({ region: process.env.AWS_REGION || "us-east-1" });
  const names = [
    "/pern/DB_USER",
    "/pern/DB_PASSWORD",
    "/pern/DB_HOST",
    "/pern/DB_NAME",
    "/pern/DB_PORT"
  ];

  const params = {
    Names: names,
    WithDecryption: true
  };

  const result = await ssm.getParameters(params).promise();
  const paramMap = {};
  result.Parameters.forEach(p => {
    const key = p.Name.split("/").pop();
    paramMap[key] = p.Value;
  });

  return {
    user: paramMap.DB_USER,
    password: paramMap.DB_PASSWORD,
    host: paramMap.DB_HOST,
    port: parseInt(paramMap.DB_PORT, 10),
    database: paramMap.DB_NAME
  };
}

async function initPool() {
  const env = process.env.NODE_ENV || "development";

  if (env === "development") {
    pool = new Pool({
      user: "postgres",
      password: "Sirsatti123!",
      host: "localhost",
      port: 5432,
      database: "tododb"
    });
  } else {
    const config = await getDBCredentialsFromSSM();
    pool = new Pool(config);
  }
}

const poolPromise = (async () => {
  await initPool();
  return pool;
})();

module.exports = poolPromise;