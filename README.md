# Cherish

[*Cherish*](https://cherish-pv.com/)
CherishはYosuke23の個人開発による、写真や動画を共有できる画像動画共有サイトです。


## Description

### CTPT frame work

#### Concept
  
機能がありすぎて逆に使いづらかったり、シンプルでも動画のアップロード時間に制限があったりしない、“なるべくカンタンに操作で使いこなせる画像動画共有アプリ”をコンセプトに開発してみました。

#### Target

- 20代〜60代
- 小さなお子さんのいるファミリー世帯層
- 既婚/独身

##### The reason

- 家族、親戚、友人間で子供や孫の成長記録を共有しあいたい
- 家族〜友人間の小規模なコミュニティで共有したい
- フィードに表示される画像動画の投稿はフォローしたユーザーのみに限定したい
- 簡易的な操作で幅広い世帯で使いこなせるような動画共有サイトがほしい
- 投稿が多くなっても検索機能で、アップ中の目当ての画像動画、またはユーザーを簡単に検索したい

#### Process

1. Product

- Railsを用いて会員登録システムを構築
- ユーザーが自由に画像、動画、コメントを投稿できるようにする

2. Place

- AWS（Amazon Web Services）を用いてWeb上に公開

3. Price

- 完全無料

4. Promotion

- 特になし

5. Process

- 家族間、またはその友人間の口コミで広げる

6. Profile

- 特になし

#### Tool

##### Development environment

* Infrastructure
  * TDD
    * Vagrant

  * Platform
    * AWS

  * Version control
    * Git

  * Web server 
    * Production
      * puma(4.1.1)

  * DB
    * Development
      * MySQL
    * Production
      * MySQL

  * Test-driven development
    * Gurad-spec(Minitest)

  * Front end language
    * HTML
    * SCSS
    * JavaScript(jQUery)

  * Back end language
    * Ruby(2.5.0)
    * Ruby on Rails(5.1.6)


## Author

[Yosuke23](https://github.com/Yosuke23/)