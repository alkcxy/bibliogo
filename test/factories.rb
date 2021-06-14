FactoryBot.define do
    factory :loan do
      factory :encicloloan do
        date { "2021-05-05" }
        expected_return { "2021-06-05" }
        actual_return { "2021-05-25" }
        reader { "Elisa" }
      end
      factory :serena do
        date { "2021-07-25" }
        expected_return { "2021-08-25" }
        reader { "Serena" }
      end
      factory :virginia do
        date { "2021-06-04" }
        expected_return { "2021-07-04" }
        reader { "Virginia" }
      end
      factory :riccardo do
        date { "2021-07-04" }
        expected_return { "2021-08-04" }
        reader { "Riccardo" }
      end
      factory :francesco do
        date { "2021-05-26" }
        expected_return { "2021-06-26" }
        reader { "Francesco" }
      end
      factory :gaia do 
        date { "2021-05-21" }
        actual_return { "2021-06-04" }
        expected_return { "2021-06-21" }
        reader { "Gaia" }
      end
      factory :filippo do 
        date { "2021-06-14" }
        expected_return { "2021-07-14" }
        reader { "Filippo" }
      end
      place { "Poggio Mirteto Scalo" }
      book
    end

    factory :book, aliases: [:enciclopedia] do
      title { "La grande enciclopedia del corpo umano" }
      authors { ["Alessio"] }
      year { 2019 }
      genre { "Scienza" }
      language { "Italiano" }
      spot { "Furgone" }
      isbn { "01234567891011" }
      code { 10 }
      catalogue { "C.123" }

      factory :book_with_loans do
        transient do
          loans_count { 1 }
        end
        after(:create) do |book, evaluator|
          create_list(:encicloloan, evaluator.loans_count, book: book)
  
          # You may need to reload the record here, depending on your application
          book.reload
        end
      end

      factory :bambina do
        title { "La bambina della sesta Luna" }
        authors { ["Witcher Moony"] }
        year { 2008 }
        genre { "Bambini/Ragazzi" }
        language { "Ita" }
        spot { "Furgone" }
        isbn { "9788809742222" }
        code { 1 }
        catalogue { "853.WIT" }
      end

      factory :mistero_elfi do
        title { "Il mistero degli elfi" }
        authors { ["Stilton, Geronimo"] }
        year { 2008 }
        genre { "Bambini/Ragazzi" }
        language { "ita" }
        spot { "Furgone" }
        isbn { "9788838499005" }
        catalogue { "853.STI" }
        abstract { "Dopo una frenetica giornata di lavoro, Geronimo sta uscendo dall'Eco del Roditore..." }
        transient do
          loans_count { 1 }
        end
        after(:create) do |book, evaluator|
          create_list(:gaia, evaluator.loans_count, book: book)
  
          # You may need to reload the record here, depending on your application
          book.reload
        end
      end
    end

    factory :setting, aliases: [:quarantine] do
      key { "quarantine" }
      value { 3 }
      factory :test do
        key { "test" }
        value { "prova" }
      end
    end
  end