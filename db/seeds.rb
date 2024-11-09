# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 外部キー制約のチェックを無効化
ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 0')

# 既存のシードデータを削除
Evaluation.delete_all
Sentence.delete_all
Title.delete_all
User.delete_all

# オートインクリメント値をリセット
ActiveRecord::Base.connection.execute('ALTER TABLE sentences AUTO_INCREMENT = 1')
ActiveRecord::Base.connection.execute('ALTER TABLE titles AUTO_INCREMENT = 1')
ActiveRecord::Base.connection.execute('ALTER TABLE users AUTO_INCREMENT = 1')
ActiveRecord::Base.connection.execute('ALTER TABLE evaluations AUTO_INCREMENT = 1')

# ユーザーのデータを作成
users = User.create!([
                       {
                         pen_name: 'コノベル太郎',
                         nick_name: 'タロさん',
                         birth_ym: '199001',
                         agreed_terms_version: 1,
                         is_anonymous: false,
                         profile_icon_image: 'icon1.png',
                         email: 'user1@example.com',
                         google_sub: 'sub1'
                       },
                       {
                         pen_name: 'コノベル二郎',
                         nick_name: 'ジロさん',
                         birth_ym: '199002',
                         agreed_terms_version: 1,
                         is_anonymous: false,
                         profile_icon_image: 'icon2.png',
                         email: 'user2@example.com',
                         google_sub: 'sub2'
                       },
                       {
                         pen_name: 'コノベル三郎',
                         nick_name: 'サブさん',
                         birth_ym: '199003',
                         agreed_terms_version: 1,
                         is_anonymous: false,
                         profile_icon_image: 'icon3.png',
                         email: 'user3@example.com',
                         google_sub: 'sub3'
                       }
                     ])

# タイトルのデータを作成
titles = Title.create!([
                         {
                           author_user_id: users[0].id,
                           title: '吾輩は猫である',
                           is_permission_violence: false,
                           is_permission_adult: false,
                           main_copy: '吾輩の大冒険',
                           overview: '吾輩の大冒険は始まったばかり！大スペクタクル冒険活劇！全米が泣いた！！'
                         }
                       ])

# 投稿のデータを作成
sentences = Sentence.create!([
                               {
                                 sentence_user_id: users[0].id,
                                 sentence: '吾輩は猫である。',
                                 parent_sentence_id: nil,
                                 title_id: titles[0].id,
                                 sentence_hierarchy: 1
                               },
                               {
                                 sentence_user_id: users[1].id,
                                 sentence: '名前はまだない。',
                                 parent_sentence_id: 1,
                                 title_id: titles[0].id,
                                 sentence_hierarchy: 2
                               },
                               {
                                 sentence_user_id: users[0].id,
                                 sentence: 'どこで生れたかとんと見当がつかぬ。',
                                 parent_sentence_id: 2,
                                 title_id: titles[0].id,
                                 sentence_hierarchy: 3
                               },
                               {
                                 sentence_user_id: users[2].id,
                                 sentence: '名前はもうある。',
                                 parent_sentence_id: 1,
                                 title_id: titles[0].id,
                                 sentence_hierarchy: 2
                               },
                               {
                                 sentence_user_id: users[1].id,
                                 sentence: '名はミケと申す。',
                                 parent_sentence_id: 4,
                                 title_id: titles[0].id,
                                 sentence_hierarchy: 3
                               },
                               {
                                 sentence_user_id: users[1].id,
                                 sentence: 'というのは嘘で、吾輩は犬である。',
                                 parent_sentence_id: 2,
                                 title_id: titles[0].id,
                                 sentence_hierarchy: 2
                               },
                               {
                                 sentence_user_id: users[1].id,
                                 sentence: '名前はポチと申す。',
                                 parent_sentence_id: 6,
                                 title_id: titles[0].id,
                                 sentence_hierarchy: 3
                               }
                             ])

# 評価のデータを作成
Evaluation.create!([
                     {
                       sentence_id: sentences[0].id,
                       evaluator_user_id: users[1].id,
                       evaluation: :good
                     },
                     {
                       sentence_id: sentences[1].id,
                       evaluator_user_id: users[0].id,
                       evaluation: :bad
                     },
                     {
                       sentence_id: sentences[2].id,
                       evaluator_user_id: users[2].id,
                       evaluation: :stay
                     }
                   ])

# 外部キー制約のチェックを再有効化
ActiveRecord::Base.connection.execute('SET FOREIGN_KEY_CHECKS = 1')
