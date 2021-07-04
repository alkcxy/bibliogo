FactoryBot.define do
    factory :user do
      password { "t34$ttestereS" }
      password_confirmation { "t34$ttestereS" }
      name { "Valeria" }
      email { "inchiostro81@gmail.com" }
    end
    factory :loan do
      factory :with_book do
        factory :encicloloan do
          date { 55.days.ago }
          expected_return { 25.days.ago }
          actual_return { 35.days.ago }
          reader { "Elisa" }
        end
        factory :serena do
          date { 35.days.since(Date.today) }
          expected_return { 65.days.since(Date.today) }
          reader { "Serena" }
        end
        factory :virginia do
          date { 16.days.ago }
          expected_return { 14.days.since(Date.today) }
          reader { "Virginia" }
        end
        factory :riccardo do
          date { 14.days.since(Date.today) }
          expected_return { 44.days.since(Date.today) }
          reader { "Riccardo" }
        end
        factory :francesco do
          date { 35.days.ago }
          expected_return { 6.days.since(Date.today) }
          reader { "Francesco" }
        end
        factory :gaia do 
          date { 29.days.ago }
          actual_return { 16.days.ago }
          expected_return { 1.day.since(Date.today) }
          reader { "Gaia" }
        end
        factory :filippo do 
          date { 6.days.ago }
          expected_return { 24.days.since(Date.today) }
          reader { "Filippo" }
        end
        place { "Poggio Mirteto Scalo" }
        book
      end
      factory :without_book do
        factory :in_loan do
          date { 12.days.ago }
          expected_return { 18.days.since(Date.today) }
          reader { "Giuseppe" }
          place { "Poggio Mirteto Scalo" }
          factory :in_quarantine do
            actual_return { 2.days.ago }
          end
          factory :lendable do
            date { 14.days.ago }
            actual_return { 12.days.ago }
          end
          factory :not_returned do
            date { 42.days.ago }
            expected_return { 12.days.ago }
          end
        end
      end
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

      factory :randomized do
        sequence(:title) { |n| "Il mistero degli elfi #{n}" }
        sequence(:isbn) { |n| "000000000#{n}" }
        sequence(:code) { |n| "#{n}" }
        sequence(:catalogue) { |n| "#{n}.WIT" }
      end
    end

    factory :setting, aliases: [:quarantine] do
      key { "quarantine" }
      value { 3 }
      factory :test do
        key { "test" }
        value { "prova" }
      end
      factory :expected_return do
        key { "expected_return" }
        value { "5" }
      end
    end

    factory :sequence do
      key { "book" }
      sequence(:value) { |n| "#{n}" }
    end
  end