'use strict';

const fs = require('fs');
const path = require('path');
const async = require('async');
const _ = require('lodash');
const got = require('got');
const testssh = require('any2api-testssh');

const ENDPOINTS_JSON = '/endpoints/endpoints.json';
const CONTEXT_DIR = '/context';
const RESULTS_JSON = CONTEXT_DIR + '/smoketest-results.json';
const POLL_STATUS_DELAY = 5 * 1000;

const csar = 'smoketest.topology';
const numOfEndpoints = 2;

let endpoints = {};
let results = [];



const getEndpoints = (csar, done) => {
  fs.access(ENDPOINTS_JSON, fs.R_OK, (err) => {
    if (err) return done(err);

    console.log('endpoints file found', ENDPOINTS_JSON);

    const endpoints = {};

    fs.readFile(ENDPOINTS_JSON, 'utf8', (err, content) => {
      if (err) return done(err);

      const parsed = JSON.parse(content);

      _.forEach(parsed, (ep) => {
        if ((ep.csar === csar || ep.csar === csar + '.csar') && ep.deployed) {
          endpoints[ep.artifactName || ep.serviceName] = ep;
        }
      });

      console.log('endpoints of CSAR', endpoints);

      done(null, endpoints);
    });
  });
};

const invokeEndpoint = (endpoints, operation, done) => {
  if (!endpoints) return done(new Error('endpoints missing'));
  else if (!operation) return done(new Error('operation missing'));

  const endpoint = endpoints[operation];

  if (!endpoint) return done(new Error('cannot determine endpoint for operation ' + operation));

  const createUrl = endpoint.endpoint + '/api/v1/executables/' + operation + '/instances';

  console.log('invoking endpoint', operation, endpoint.artifactName, endpoint.serviceName, createUrl);

  got.post(createUrl, {
    headers: {
      'content-type': 'application/json'
    },
    query: {
      embed_all_results: true,
      embed_all_parameters: true
    },
    body: JSON.stringify({
      parameters: {
        invoker_config: {
          access: 'ssh',
          ssh_host: endpoints.sshserver.containerIp || 'localhost',
          ssh_port: endpoints.sshserver.containerPort || '22', // .publicPort
          ssh_user: testssh.username,
          ssh_private_key: testssh.privateKey
        }
      }
    }),
    json: true
  }).then(response => {
    const instanceUrl = endpoint.endpoint + response.body._links.self.href;
    let instance = response.body;

    console.log('instance created', instance);

    async.whilst(function() {
      return instance.status === 'running';
    }, function(done) {
      got(instanceUrl, {
        query: {
          embed_all_results: true,
          embed_all_parameters: true
        },
        json: true
      }).then(response => {
        instance = response.body;

        console.log('instance status:', instance.status, instanceUrl);

        if (instance.status === 'running') setTimeout(done, POLL_STATUS_DELAY);
        else done();
      }).catch(err => {
        done(err);
      });
    }, (err) => {
      if (err) return done(err);

      instance.endpoint = endpoint;

      done(null, instance);
    });
  }).catch(err => {
    done(err);
  });
};



async.series([
  function(done) {
    getEndpoints(csar, (err, eps) => {
      endpoints = eps;

      if (err) done(err);
      else if (_.size(endpoints) < numOfEndpoints) done(new Error('CSAR deployment failed: at least one IA endpoint missing'));

      done();
    });
  },
  function(done) {
    async.eachSeries([
      'install-nodejs'
    ], function(operation, done) {
      invokeEndpoint(endpoints, operation, (err, result) => {
        results.push(result);
        done(err);
      });
    }, done);
  },
  function(done) {
    results = JSON.stringify(results, null, 2);

    console.log('final results', results);

    fs.writeFile(RESULTS_JSON, results, done);
  }
], (err) => {
  if (err) throw err;
});
