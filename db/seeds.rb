# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Account.create([
#     {name_en: "Assets", name_ar: "الأصول", account_number: 1},
#     {name_en: "Current Assets", name_ar: "الأصول المتداولة", account_number: 11},
#     {name_en: "Liabilities", name_ar: "الخصوم", account_number: 2},
#     {name_en: "Not Current Assets", name_ar: "الأصول غير المتداولة", account_number: 12},
#     {name_en: "Income", name_ar: "الإيرادات", account_number: 3},
#     {name_en: "Expenses", name_ar: "المصروفات", account_number: 4},
#     {name_en: "Capital and Equity", name_ar: "رأس المال و حقوق الملكية", account_number: 5},
#     {name_en: "Current Liabilities", name_ar: "الخصوم المتداولة", account_number: 21},
#     {name_en: "allotments", name_ar: "المخصصات", account_number: 22},
#     {name_en: "non-activity revenue", name_ar: "ايرادات من غير النشاط", account_number: 31},
#     {name_en: "Receivables", name_ar: "ذمم مدينة", account_number: 111},
#     {name_en: "Revenue from current activity", name_ar: "ايرادات النشاط الجاري", account_number: 32},
# ])

Currency.create([
    {name_en: "Saudi Riyals", name_ar: "ريال سعودى"},
    {name_en: "Egyptian Pound", name_ar: "جنيه مصرى"},
    {name_en: "American Dollar", name_ar: "دولار أمريكى"},
])

CostCenter.create([
    {name_en: "Assets", name_ar: "حساب الأصول"}
])
