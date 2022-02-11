/**
 * Return the GraphQl query for verifying the request is what we expect inside of cy.intercept
 * @param {String} conceptId conceptId to retrieve
 */
export const graphQlGetCollection = conceptId => `{"query":"\\n    query GetCollection(\\n      $id: String!\\n      $includeHasGranules: Boolean\\n      $includeTags: String\\n      $subscriberId: String\\n    ) {\\n      collection (\\n        conceptId: $id\\n        includeHasGranules: $includeHasGranules\\n        includeTags: $includeTags\\n      ) {\\n        abstract\\n        archiveAndDistributionInformation\\n        associatedDois\\n        boxes\\n        conceptId\\n        coordinateSystem\\n        dataCenter\\n        dataCenters\\n        directDistributionInformation\\n        doi\\n        hasGranules\\n        lines\\n        nativeDataFormats\\n        points\\n        polygons\\n        relatedUrls\\n        relatedCollections (\\n          limit: 3\\n        ) {\\n          count\\n          items {\\n              id\\n              title\\n            }\\n          }\\n        }\\n        scienceKeywords\\n        shortName\\n        spatialExtent\\n        tags\\n        temporalExtents\\n        tilingIdentificationSystems\\n        title\\n        versionId\\n        services {\\n          count\\n          items {\\n            conceptId\\n            longName\\n            name\\n            type\\n            url\\n            serviceOptions\\n            supportedOutputProjections\\n            supportedReformattings\\n          }\\n        }\\n        granules {\\n          count\\n          items {\\n            conceptId\\n            onlineAccessFlag\\n          }\\n        }\\n        subscriptions (\\n          subscriberId: $subscriberId\\n        ) {\\n          count\\n          items {\\n            collectionConceptId\\n            conceptId\\n            name\\n            nativeId\\n            query\\n          }\\n        }\\n        tools {\\n          count\\n          items {\\n            longName\\n            name\\n            potentialAction\\n          }\\n        }\\n        variables {\\n          count\\n          items {\\n            conceptId\\n            definition\\n            longName\\n            name\\n            nativeId\\n            scienceKeywords\\n          }\\n        }\\n      }\\n    }","variables":{"id":"${conceptId}","includeHasGranules":true,"includeTags":"edsc.*,opensearch.granule.osdd"}}`
