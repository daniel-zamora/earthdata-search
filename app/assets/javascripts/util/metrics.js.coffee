# Info for tracking query times, EDSC-595, https://developers.google.com/analytics/devguides/collection/analyticsjs/user-timings
# Info for tracking button/link clicks, EDSC-596, https://developers.google.com/analytics/devguides/collection/analyticsjs/events , possibly use this for tracking data access options, EDSC-599



this.edsc.util.metrics = do ->

  createPageView: (path, state) ->
    if ga?
      # set custom dimensions to track other stuff
      # Dimension 1, keyword search
      ga('set', 'dimension1', if state.free_text? then state.free_text.toLowerCase() else null)

      # Dimension 2, spatial type
      spatial = null
      spatial = 'Bounding Box' if state.bounding_box?
      spatial = 'Polygon' if state.polygon?
      spatial = 'Point' if state.point?
      ga('set', 'dimension2', spatial)

      # Dimension 3, temporal type
      temporal = null
      if state.temporal?
        if state.temporal.split(',').length > 2
          temporal = 'Recurring Temporal'
        else
          temporal = 'Standard Temporal'
      ga('set', 'dimension3', temporal)

      # Dimension 4, datasets viewed
      # Dimension 5, datasets added to project
      d4 = null
      d5 = null
      if state.p?
        datasetIds = state.p.split('!')
        for id, index in datasetIds
          if id.length > 0
            if index == 0
              d4 = id
            else
              d5 = id
      ga('set', 'dimension4', d4)
      ga('set', 'dimension5', d5)

      # Dimension 6, Search facets
      facet_names = ['features', 'archive_center', 'project', 'platform', 'instrument', 'sensor', 'two_d_coordinate_system_name', 'processing_level_id']
      facets = []
      for name in facet_names when state[name]?
        facets.push("#{name}/#{value}") for value in state[name]

      if state.science_keywords?
        keyword_names = ['category', 'topic', 'term', 'variable_level_1', 'variable_level_2', 'variable_level_3', 'detailed_variable']
        for name in keyword_names when state.science_keywords[0][name]?
          facets.push("#{name}/#{value}") for value in state.science_keywords[0][name]

      ga('set', 'dimension6', if facets.length > 0 then facets.join(' ') + ' ' else null)


      # Send the page view
      ga('send', 'pageview', path)
