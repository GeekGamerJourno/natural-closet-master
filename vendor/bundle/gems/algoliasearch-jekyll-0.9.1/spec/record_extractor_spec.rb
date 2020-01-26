require 'spec_helper'

describe(AlgoliaSearchRecordExtractor) do
  let(:extractor) { AlgoliaSearchRecordExtractor }
  let(:site) { get_site }
  let(:page_file) { extractor.new(site.file_by_name('about.md')) }
  let(:html_page_file) { extractor.new(site.file_by_name('authors.html')) }
  let(:post_file) { extractor.new(site.file_by_name('test-post.md')) }
  let(:hierarchy_page_file) { extractor.new(site.file_by_name('hierarchy.md')) }
  let(:weight_page_file) { extractor.new(site.file_by_name('weight.md')) }
  let(:document_file) { extractor.new(site.file_by_name('collection-item.md')) }

  before(:each) do
    # Disabling the logs, while still allowing to spy them
    Jekyll.logger = double('Specific Mock Logger').as_null_object
    @logger = Jekyll.logger.writer
  end

  describe 'metadata' do
    it 'gets metadata from page' do
      # Given
      actual = page_file.metadata

      # Then
      expect(actual[:type]).to eq 'page'
      expect(actual[:slug]).to eq 'about'
      expect(actual[:title]).to eq 'About page'
      expect(actual[:url]).to eq '/about.html'
      expect(actual[:custom]).to eq 'Foo'
    end

    it 'gets metadata from post' do
      # Given
      actual = post_file.metadata

      # Then
      expect(actual[:slug]).to eq 'test-post'
      expect(actual[:title]).to eq 'Test post'
      expect(actual[:url]).to eq '/2015/07/02/test-post.html'
      expect(actual[:posted_at]).to eq 1_435_788_000
      expect(actual[:custom]).to eq 'Foo'
    end

    it 'gets posted_at timestamp based on the configured timezone' do
      # Given
      site = get_site(timezone: 'America/New_York')
      post_file = extractor.new(site.file_by_name('test-post.md'))
      actual = post_file.metadata

      # Then
      expect(actual[:posted_at]).to eq 1_435_809_600
    end

    it 'gets metadata from document' do
      # Given
      actual = document_file.metadata

      # Then
      expect(actual[:type]).to eq 'document'
      expect(actual[:slug]).to eq 'collection-item'
      expect(actual[:title]).to eq 'Collection Item'
      expect(actual[:url]).to eq '/my-collection/collection-item.html'
      expect(actual[:custom]).to eq 'Foo'
    end

    if restrict_jekyll_version(more_than: '3.0')
      describe 'Jekyll > 3.0' do
        it 'should not throw any deprecation warnings' do
          # Given

          # When
          post_file.metadata

          # Expect
          expect(@logger).to_not have_received(:warn)
        end
      end

    end
  end

  describe 'slug' do
    it 'gets it from data if available' do
      # Given
      post_file.file.data['slug'] = 'foo'
      allow(post_file.file).to receive(:respond_to?).with(:slug) do
        false
      end

      # When
      actual = post_file.slug

      # Then
      expect(actual).to eql('foo')
    end

    it 'gets it from the root if not in data' do
      # Given
      post_file.file.data.delete 'slug'
      allow(post_file.file).to receive(:slug).and_return('foo')

      # When
      actual = post_file.slug

      # Then
      expect(actual).to eql('foo')
    end

    it 'gets it from the data even if in the root' do
      # Given
      post_file.file.data['slug'] = 'foo'
      allow(post_file.file).to receive(:slug).and_return('bar')

      # When
      actual = post_file.slug

      # Then
      expect(actual).to eql('foo')
    end

    it 'guesses it from the path if not found' do
      # Given
      post_file.file.data.delete 'slug'
      allow(post_file.file).to receive(:respond_to?).with(:slug) do
        false
      end
      allow(post_file.file).to receive(:path) do
        '/path/to/file/foo.html'
      end

      # When
      actual = post_file.slug

      # # Then
      expect(actual).to eql('foo')
    end
  end

  describe 'tags' do
    it 'returns tags in data if available' do
      # Given
      post_file.file.data['tags'] = %w(foo bar)
      allow(post_file.file).to receive(:respond_to?).with(:tags) do
        false
      end

      # When
      actual = post_file.tags

      # Then
      expect(actual).to include('foo', 'bar')
    end

    it 'returns tags at the root if not in data' do
      # Given
      post_file.file.data.delete 'tags'
      allow(post_file.file).to receive(:tags).and_return(%w(foo bar))

      # When
      actual = post_file.tags

      # Then
      expect(actual).to include('foo', 'bar')
    end

    it 'returns tags in data even if in root' do
      # Given
      post_file.file.data['tags'] = %w(foo bar)
      allow(post_file.file).to receive(:tags).and_return(%w(js css))

      # When
      actual = post_file.tags

      # Then
      expect(actual).to include('foo', 'bar')
    end

    it 'parses tags as string if they are another type' do
      # Given
      tag_foo = double('Extended Tag', to_s: 'foo')
      tag_bar = double('Extended Tag', to_s: 'bar')
      post_file.file.data['tags'] = [tag_foo, tag_bar]
      allow(post_file.file).to receive(:respond_to?).with(:tags) do
        false
      end

      # When
      actual = post_file.tags

      # Then
      expect(actual).to include('foo', 'bar')
    end

    it 'extract tags from front matter' do
      # Given
      actual = post_file.tags

      # Then
      expect(actual).to include('tag', 'another tag')
    end
  end

  describe 'html_nodes' do
    it 'returns the list of all <p> by default' do
      expect(page_file.html_nodes.size).to eq 6
    end

    it 'allow _config.yml to override the selector' do
      # Given
      site = get_site(algolia: { 'record_css_selector' => 'p,ul' })
      page_file = extractor.new(site.file_by_name('about.md'))

      expect(page_file.html_nodes.size).to eq 7
    end
  end

  describe 'node_heading_parent' do
    it 'returns the direct heading right above' do
      # Given
      nodes = hierarchy_page_file.html_nodes
      p = nodes[0]

      # When
      actual = hierarchy_page_file.node_heading_parent(p)

      # Then
      expect(actual.name).to eq 'h1'
      expect(actual.text).to eq 'H1'
    end

    it 'returns the closest heading even if in a sub tag' do
      # Given
      nodes = hierarchy_page_file.html_nodes
      p = nodes[2]

      # When
      actual = hierarchy_page_file.node_heading_parent(p)

      # Then
      expect(actual.name).to eq 'h2'
      expect(actual.text).to eq 'H2A'
    end

    it 'should automatically go up one level when indexing headings' do
      # Given
      site = get_site(algolia: { 'record_css_selector' => 'p,h2' })
      hierarchy_page_file = extractor.new(site.file_by_name('hierarchy.md'))
      nodes = hierarchy_page_file.html_nodes
      h2 = nodes[4]

      # When
      actual = hierarchy_page_file.node_heading_parent(h2)

      # Then
      expect(actual.name).to eq 'h1'
      expect(actual.text).to eq 'H1'
    end

    it 'should find the correct parent when indexing deep headings' do
      # Given
      site = get_site(algolia: { 'record_css_selector' => 'h2' })
      hierarchy_page_file = extractor.new(site.file_by_name('hierarchy.md'))
      nodes = hierarchy_page_file.html_nodes
      h2 = nodes[2]

      # When
      actual = hierarchy_page_file.node_heading_parent(h2)

      # Then
      expect(actual.name).to eq 'h1'
      expect(actual.text).to eq 'H1'
    end
  end

  describe 'node_hierarchy' do
    it 'returns the unique parent of a simple element' do
      # Note: First <p> should only have a h1 as hierarchy
      # Given
      nodes = hierarchy_page_file.html_nodes
      p = nodes[0]

      # When
      actual = hierarchy_page_file.node_hierarchy(p)

      # Then
      expect(actual).to include(h1: 'H1')
    end

    it 'returns the heading hierarchy of multiple headings' do
      # Note: 5th <p> is inside h3, second h2 and main h1
      # Given
      nodes = hierarchy_page_file.html_nodes
      p = nodes[4]

      # When
      actual = hierarchy_page_file.node_hierarchy(p)

      # Then
      expect(actual).to include(h1: 'H1', h2: 'H2B', h3: 'H3A')
    end

    it 'works even if heading not on the same level' do
      # Note: The 6th <p> is inside a div
      # Given
      nodes = hierarchy_page_file.html_nodes
      p = nodes[5]

      # When
      actual = hierarchy_page_file.node_hierarchy(p)

      # Then
      expect(actual).to include(h1: 'H1', h2: 'H2B', h3: 'H3A', h4: 'H4')
    end

    it 'includes node in the output if headings are indexed' do
      # Given
      site = get_site(algolia: { 'record_css_selector' => 'h1' })
      hierarchy_page_file = extractor.new(site.file_by_name('hierarchy.md'))
      nodes = hierarchy_page_file.html_nodes
      h1 = nodes[0]

      # When
      actual = hierarchy_page_file.node_hierarchy(h1)

      # Then
      expect(actual).to include(h1: 'H1')
    end

    it 'escape html in headings' do
      # Given
      nodes = hierarchy_page_file.html_nodes
      p = nodes[7]

      # When
      actual = hierarchy_page_file.node_hierarchy(p)

      # Then
      expect(actual).to include(h3: 'H3B &lt;code&gt;')
    end
  end

  describe 'node_raw_html' do
    it 'returns html including surrounding tags' do
      # Note: 3rd <p> is a real HTML with a custom class
      # Given
      nodes = page_file.html_nodes
      p = nodes[3]

      # When
      actual = page_file.node_raw_html(p)

      # Then
      expect(actual).to eq '<p id="text4">Another text 4</p>'
    end
  end

  describe 'node_text' do
    it 'returns inner text with <> escaped' do
      # Note: 4th <p> contains a <code> tag with <>
      # Given
      nodes = page_file.html_nodes
      p = nodes[4]

      # When
      actual = page_file.node_text(p)

      # Then
      expect(actual).to eq 'Another &lt;text&gt; 5'
    end
  end

  describe 'unique_hierarchy' do
    it 'combines title and headings' do
      # Given
      hierarchy = {
        title: 'title',
        h1: 'h1',
        h2: 'h2',
        h3: 'h3',
        h4: 'h4',
        h5: 'h5',
        h6: 'h6'
      }

      # When
      actual = page_file.unique_hierarchy(hierarchy)

      # Then
      expect(actual).to eq 'title > h1 > h2 > h3 > h4 > h5 > h6'
    end

    it 'combines title and headings even with missing elements' do
      # Given
      hierarchy = {
        title: 'title',
        h2: 'h2',
        h4: 'h4',
        h6: 'h6'
      }

      # When
      actual = page_file.unique_hierarchy(hierarchy)

      # Then
      expect(actual).to eq 'title > h2 > h4 > h6'
    end
  end

  describe 'node_css_selector' do
    it 'uses the #id to make the selector more precise if one is found' do
      # Given
      nodes = page_file.html_nodes
      p = nodes[3]

      # When
      actual = page_file.node_css_selector(p)

      # Then
      expect(actual).to eq '#text4'
    end

    it 'uses p:nth-of-type if no #id found' do
      # Given
      nodes = page_file.html_nodes
      p = nodes[2]

      # When
      actual = page_file.node_css_selector(p)

      # Then
      expect(actual).to eq 'p:nth-of-type(3)'
    end

    it 'handles custom <div> markup' do
      # Given
      nodes = page_file.html_nodes
      p = nodes[5]

      # When
      actual = page_file.node_css_selector(p)

      # Then
      expect(actual).to eq 'div:nth-of-type(2) > p'
    end
  end

  describe 'weight_heading_relevance' do
    it 'gets the number of words in text also in the title' do
      # Given
      data = {
        title: 'foo bar',
        text: 'Lorem ipsum dolor foo bar, consectetur adipiscing elit'
      }

      # When
      actual = page_file.weight_heading_relevance(data)

      # Then
      expect(actual).to eq 2
    end

    it 'gets the number of words in text also in the headings' do
      # Given
      data = {
        title: 'foo',
        h1: 'bar',
        h2: 'baz',
        text: 'Lorem baz dolor foo bar, consectetur adipiscing elit'
      }

      # When
      actual = page_file.weight_heading_relevance(data)

      # Then
      expect(actual).to eq 3
    end

    it 'count each word only once' do
      # Given
      data = {
        title: 'foo',
        h1: 'foo foo foo',
        h2: 'bar bar foo bar',
        text: 'foo bar bar bar bar baz foo bar baz'
      }

      # When
      actual = page_file.weight_heading_relevance(data)

      # Then
      expect(actual).to eq 2
    end

    it 'is case-insensitive' do
      # Given
      data = {
        title: 'FOO',
        h1: 'bar Bar BAR',
        text: 'foo BAR'
      }

      # When
      actual = page_file.weight_heading_relevance(data)

      # Then
      expect(actual).to eq 2
    end

    it 'should only use words, no partial matches' do
      # Given
      data = {
        title: 'foo bar',
        text: 'xxxfooxxx bar'
      }

      # When
      actual = page_file.weight_heading_relevance(data)

      # Then
      expect(actual).to eq 1
    end

    it 'should still work with non-string keys' do
      # Given
      data = {
        title: nil,
        h1: [],
        h2: {},
        h3: true,
        h4: false,
        h5: 'foo bar',
        text: 'foo bar'
      }

      # When
      actual = page_file.weight_heading_relevance(data)

      # Then
      expect(actual).to eq 2
    end
  end

  describe 'weight_tag_name' do
    it 'gives a score of 0 to non-headings' do
      # Given
      data = {
        tag_name: 'p'
      }

      # When
      actual = page_file.weight_tag_name(data)

      # Then
      expect(actual).to eq 0
    end
    it 'gives a score of 100 to h1' do
      # Given
      data = {
        tag_name: 'h1'
      }

      # When
      actual = page_file.weight_tag_name(data)

      # Then
      expect(actual).to eq 100
    end
    it 'gives a score of 40 to h6' do
      # Given
      data = {
        tag_name: 'h6'
      }

      # When
      actual = page_file.weight_tag_name(data)

      # Then
      expect(actual).to eq 50
    end
  end

  describe 'weight' do
    it 'returns an object with all weights' do
      # Given
      item = {
        tag_name: 'p'
      }
      allow(page_file).to receive(:weight_tag_name) { 10 }
      allow(page_file).to receive(:weight_heading_relevance) { 20 }

      # When
      actual = page_file.weight(item, 42)

      # Then
      expect(actual).to include(tag_name: 10)
      expect(actual).to include(heading_relevance: 20)
      expect(actual).to include(position: 42)
    end
  end

  describe 'custom_hook_each' do
    it 'let the user call a custom hook to modify a record' do
      # Given
      def page_file.custom_hook_each(item, _)
        item[:custom_attribute] = 'foo'
        item
      end

      # When
      actual = page_file.extract

      # Then
      expect(actual[0]).to include(custom_attribute: 'foo')
    end

    it 'let the user discard a record by returning nil' do
      # Given
      def page_file.custom_hook_each(_, _)
        nil
      end

      # When
      actual = page_file.extract

      # Then
      expect(actual.size).to eq 0
    end
  end

  describe 'custom_hook_all' do
    it 'let the user call a custom hook to modify the list of records' do
      # Given
      def page_file.custom_hook_all(items)
        [items[0], { foo: 'bar' }]
      end

      # When
      actual = page_file.extract

      # Then
      expect(actual.size).to eq 2
      expect(actual[1]).to include(foo: 'bar')
    end
  end
end
