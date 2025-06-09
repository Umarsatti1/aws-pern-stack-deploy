const { SSM } = require('aws-sdk');
const { Pool } = require('pg');

const ssm = new SSM();

async function getParams() {
  const names = [
    '/pern/PGUSER',
    '/pern/PGPASSWORD',
    '/pern/PGHOST',
    '/pern/PGPORT',
    '/pern/PGDATABASE'
  ];

  const params = {
    Names: names,
    WithDecryption: true
  };

  const result = await ssm.getParameters(params).promise();

  const paramMap = Object.fromEntries(
    result.Parameters.map(p => [p.Name.split('/').pop(), p.Value])
  );

  return new Pool({
    user: paramMap.PGUSER,
    password: paramMap.PGPASSWORD,
    host: paramMap.PGHOST,
    port: parseInt(paramMap.PGPORT, 10),
    database: paramMap.PGDATABASE
  });
}

module.exports = getParams;
