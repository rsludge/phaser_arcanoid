class PhaserArcanoid
  preload: =>
    @game.load.image('ground', '../assets/images/ground.png')
    @game.load.image('desk', '../assets/images/desk.png')
    @game.load.image('ball', '../assets/images/ball.png')
    @game.load.image('brick', '../assets/images/brick.png')

  create: =>
      @game.physics.startSystem(Phaser.Physics.ARCADE)

      @ground = @game.add.sprite(0, @game.world.height - 20, 'ground')
      @desk = @game.add.sprite(20, @game.world.height - 34, 'desk')
      @ball = @game.add.sprite(26, @game.world.height - 144, 'ball')

      @bricks = @game.add.group()

      @center_text = @game.add.text(260, @game.world.height / 2 - 16, '', { fontSize: 44, fill: '#fff' })
      @lives_text = @game.add.text(2, @game.world.height - 16, 'Lives: ' + @lives, { fontSize: 14, fill: '#fff' })
      @lives_text.fontSize = 14

      @game.physics.arcade.enable(@ground)
      @game.physics.arcade.enable(@desk)
      @game.physics.arcade.enable(@ball)
      @bricks.enableBody = true

      this.setupLevel(@current_level)

      @ground.body.immovable = true

      @desk.body.immovable = true
      @desk.body.collideWorldBounds = true
      @ball.body.collideWorldBounds = true

      @ball.body.bounce.x = 1.0
      @ball.body.bounce.y = 1.0

      @ball.body.velocity.y = -250
      @ball.body.velocity.x = -250

      @cursors = @game.input.keyboard.createCursorKeys()


  update: =>
      @game.physics.arcade.collide(@desk, @ground)
      @game.physics.arcade.collide(@desk, @ball)
      @game.physics.arcade.collide(@ball, @ground, this.ballFalled, null, this)
      @game.physics.arcade.collide(@ball, @bricks, this.collectBrick, null, this)
      if @cursors.left.isDown
          @desk.body.velocity.x = -200
      else if @cursors.right.isDown
          @desk.body.velocity.x = 200
      else if @cursors.down.isDown
          @desk.body.velocity.x = 0

  collectBrick: (ball, brick) ->
      brick.kill()
      if @bricks.total == 0
        @current_level += 1
        this.setupLevel(@current_level)

  ballFalled: (ball, ground) ->
    @lives -= 1
    @lives_text.text = 'Lives: ' + @lives
    if @lives == 0
      this.showPopup('You are looser!')
      ball.destroy()

  setupLevel: (level) ->
    for coords in @levels[level]
      brick = @bricks.create(coords[0], coords[1], 'brick')
      brick.body.immovable = true
    this.showPopup('Level ' + (level+1))

  showPopup: (popup_text) ->
     @center_text.text = popup_text
     instance = this
     setTimeout(->
       instance.center_text.text = ''
     , 3000)

  start: ->
    @levels = [
      [[0, 0], [40, 0], [80, 0], [120, 0], [160, 0], [200, 0], [240, 0], [280, 0], [320, 0], [360, 0], [400, 0],[440, 0], [480, 0], [520, 0], [560,0], [600, 0], [0, 24], [40, 24], [80, 24], [120, 24], [160, 24], [200, 24], [240, 24], [280, 24], [320, 24], [360, 24], [400, 24],[440, 24], [480, 24], [520, 24], [560, 24], [600, 24]],
      [[10, 10], [50, 10], [90, 10], [130, 10], [170, 10], [210, 10]],
    ]

    @current_level = 0
    @lives = 5
    @game = new Phaser.Game(640, 600, Phaser.AUTO, '', { preload: this.preload, create: this.create, update: this.update })

arcanoid = new PhaserArcanoid
arcanoid.start()
