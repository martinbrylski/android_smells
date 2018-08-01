# Export Plugin
module.exports = (BasePlugin) ->
    # Define Plugin
    class RelurlRoot extends BasePlugin
        # Plugin Name
        name: 'relurl'

        # Parsing all files has finished
        parseAfter: (opts,next) ->
            # Prepare
            docpad = @docpad
            docpad.log 'debug', 'Creating paths to root'
            documents = docpad.getCollection('documents')

            # Find documents
            documents.forEach (document) ->
                # Prepare
                documentUrl = document.get('relativePath')
                depth = documentUrl.split('/').length;
                relurl = ['.']
                if depth > 2
                    relurl.push('..') for i in [0..depth-3]

                document.set('relurl', relurl.join('/'))
            next()?
