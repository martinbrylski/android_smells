# DocPad Configuration File
# http://docpad.org/docs/config

# Define the DocPad Configuration
docpadConfig = {
    growl: false
    renderPasses: 2

    plugins:
        lunr:
            indexes:
                smellIndex:
                    collection: 'smells'

	templateData:
        site:
            title: "Android Smells Catalogue"
            description: "Listing of Android Bad Coding Smells"
            url: process.cwd() + '/out'

        # Get the Absolute URL of a document
        getUrl: (_, site) ->
            site = site || @site.url

            if (typeof _ == "string")
                if (_[0] == "/" && _[1] != "/")
                    return site+_
                return _

            if (typeof _ == "object")
                if (_.url)
                    return @getUrl(_.url,site)
                if (_.map)
                    _getUrl = arguments.callee
                    return _.map((d) ->
                        return _getUrl(d,site)
                    )

            return _

        getRelativeUrl: (site) ->
            absUrl = @getUrl(site)

            relUrl = (@document.outDirPath.replace(absUrl.replace((site.url or site), ''), '').replace(/\/[^\/]+/g, '../') + (site.url or site)).replace('//', '/')
            if relUrl[0] == '/'
                relUrl = relUrl.substr(1, relUrl.length)

            return relUrl



        getRefactorings: ->
            refactorings = []

            for refactoring in (@document.refactorings or [])
                refName = refactoring.toLowerCase().replace(/^\s*-/g, '')
                refFile = @getFile({relativeOutDirPath:'refactorings', name: new RegExp(refName, 'gi') })
                if refFile
                    refactorings.push(refFile.attributes.url)

            return refactorings

        getPreparedTitle: -> if @document.title then "#{@document.title} | #{@site.title}" else @site.title

        # Get the prepared site/document description
        getPreparedDescription: ->
            # if we have a document description, then we should use that, otherwise use the site's description
            return @document.description or @site.description

        # Get the prepared site/document keywords
        getPreparedKeywords: ->
            # Merge the document keywords with the site keywords
            return @site.keywords.concat(@document.keywords or []).join(', ')


        qualitiesOfSmells: ->
            qualities = []
            for smell in @getCollection("smells").toJSON()
                for quality in @parseListBlock(smell.affects)
                    qualities.push(quality) if quality not in qualities
            qualities.sort( (q1, q2) -> if q1 <= q2 then -1 else 1 )

        qualitiesMapOfRefactoring: (refactoring) ->
            qualities = {}

            for quality in @parseListBlock(refactoring.affectsPositive)
                qualities[quality] = 'positive' if quality not in qualities
            for quality in @parseListBlock(refactoring.affectsNegative)
                qualities[quality] = 'negative' if quality not in qualities

            qualities

        qualitiesOfRefactorings: ->
            qualities = []
            for refactoring in @getCollection("refactorings").toJSON()
                for quality in @parseListBlock(refactoring.affectsPositive)
                    qualities.push(quality) if quality not in qualities
                for quality in @parseListBlock(refactoring.affectsNegative)
                    qualities.push(quality) if quality not in qualities
            qualities.sort( (q1, q2) -> if q1 <= q2 then -1 else 1 )

        contextsOfSmells: ->
            contexts = []
            for smell in @getCollection("smells").toJSON()
                for context in @parseListBlock(smell.context)
                    contexts.push(context) if context not in contexts
            contexts.sort( (c1, c2) -> if c1 <= c2 then -1 else 1 )

        parseListBlock: (block) ->
            entries= []
            if not not block
                entries = (line.replace(/^\s*-/g, '') for line in block)
            entries

    collections:
        pages: ->
            @getCollection("html").findAllLive({isPage:true},[{navOrder:1}])

        smells: ->
            @getCollection("html").findAllLive({relativeOutDirPath:'smells'},[{title:1}])

        refactorings: ->
            @getCollection("html").findAllLive({relativeOutDirPath:'refactorings'},[{title:1}])

}

# Export the DocPad Configuration
module.exports = docpadConfig
