RSpec.describe TMDBApi do
  # Тестируем создание YML файла с нужными данными на одном заранее известном мувике
  let(:tmdb) { TMDBApi.new }
  let(:movies) { MovieProduction::MovieCollection.new.filter(title: 'Fight Club') }

  before do
    stub_const("TMDBApi::YML_FILE_PATH", File.expand_path("spec/yml_data/test_movies_info.yml"))
  end

  describe "#fetch_data" do
    it 'creates YML with TMDB movie info' do
      VCR.use_cassette('fight_club_tmdb_request') do
        tmdb.fetch_info(movies)
        yaml_data = YAML.load_file(TMDBApi::YML_FILE_PATH)
        expect(yaml_data['tt0137523']['poster_path']).to eq "/hTjHSmQGiaUMyIx3Z25Q1iktCFD.jpg"
        expect(yaml_data['tt0137523']['title']).to eq "Бойцовский клуб"
      end
    end
  end
end
