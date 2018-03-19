@edsc.models.data.Granule = do (ko
                                DetailsModel = @edsc.models.DetailsModel
                                extend = $.extend
                                scalerUrl = @edsc.config.browseScalerUrl
                                ajax = @edsc.util.xhr.ajax
                                ) ->

  class Granule extends DetailsModel
    constructor: (jsonData) ->
      extend(this, jsonData)
      @details = @asyncComputed({}, 100, @_computeGranuleDetails, this)
      @detailsLoaded = ko.observable(false)
      @browseError = ko.observable(false)
      @dataLinks = ko.observableArray([])
      @download_now_urls()

    edsc_browse_url: (w, h) ->
      w ?= 170
      h ?= w
      "#{scalerUrl}/browse_images/granules/#{@id}?h=#{h}&w=#{w}"

    edsc_full_browse_url: ->
      for link in @links
        return link.href if link.rel.indexOf('browse') != -1
      null

    download_now_urls: ->
      links = []
      filter = []
      if @links? && @links.length > 0
        # Step one - add all links that are 'http' and are not inherited
        links.push(link) for link in @links when link.rel.indexOf('/data#') != -1 && link.href.indexOf('http') != -1 && link.inherited != true
        # Step two - create 'filter' array which stores the file names of all previous http links
        filter.push(link.href.substr(link.href.lastIndexOf('/') + 1).replace(".html", "")) for link in @links when link.rel.indexOf('/data#') != -1 && link.href.indexOf('http') != -1 && link.inherited != true
        # Step three - add all links that are 'ftp' which call filenames that are *not* in the filter (meaning, have not already
        # been added with an http link)
        links.push(link) for link in @links when link.rel.indexOf('/data#') != -1 && link.href.indexOf('ftp://') != -1 && filter.indexOf(link.href.substr(link.href.lastIndexOf('/') + 1)) == -1 && link.inherited != true

      @dataLinks(links)

    onThumbError: (granule) ->
      @browseError(true)

    getTemporal: ->
      time_end = @_normalizeTime(@time_end)
      time_start = @_normalizeTime(@time_start)

      return [time_start, null] if time_start == time_end
      return [time_start, null] unless time_end?
      return [null, time_end] unless time_start?

      [time_start, time_end]

    humanizeTemporal: ->
      [start, end] = @getTemporal()
      return "#{start} to #{end}" if start && end
      return "Start: #{start}" if start
      return "End: #{end}" if end

    _normalizeTime: (time) ->
      return null unless time?
      time.replace(/([0-9-]+)T([0-9:]+)\.0+Z/, '$1 $2')

    equals: (other) ->
      other.id == @id

    displayName: ->
      if this.producer_granule_id?
        this.producer_granule_id
      else
        this.title

    getFileName: (str) ->
      filename = str.substring(str.lastIndexOf('/')+1);

  exports = Granule
