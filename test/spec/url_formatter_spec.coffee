URLFormatter = require '../../src/url_formatter'

describe 'URLFormatter', ->
  beforeEach ->
    @formatter = new URLFormatter '/users/:userId/threads/:threadId'

  describe '#replaceParams', ->
    context 'called with positional arguments', ->
      beforeEach ->
        @formattedUrl = @formatter.replaceParams 1, 2

      it 'replaces each param in order', ->
        expect(@formattedUrl).to.equal '/users/1/threads/2'

      it 'replaces params in subsequent calls', ->
        expect(@formatter.replaceParams 3, 4).to.equal '/users/3/threads/4'


    context 'called with an object', ->
      beforeEach ->
        @formattedUrl = @formatter.replaceParams threadId: 6, userId: 5

      it 'replaces each param', ->
        expect(@formattedUrl).to.equal '/users/5/threads/6'

      it 'replaces params in subsequent calls', ->
        expect(@formatter.replaceParams threadId: 7, userId: 8).to.equal '/users/8/threads/7'
