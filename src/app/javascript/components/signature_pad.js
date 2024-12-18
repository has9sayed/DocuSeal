class SignaturePad {
  constructor(canvas, options = {}) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.points = [];
    this.isDrawing = false;

    this.options = {
      penColor: options.penColor || '#000000',
      penWidth: options.penWidth || 2,
      backgroundColor: options.backgroundColor || 'rgba(255, 255, 255, 0)',
      ...options
    };

    this.setupCanvas();
    this.attachEvents();
  }

  setupCanvas() {
    // Set canvas size to match display size
    const rect = this.canvas.getBoundingClientRect();
    this.canvas.width = rect.width;
    this.canvas.height = rect.height;

    // Set initial styles
    this.ctx.strokeStyle = this.options.penColor;
    this.ctx.lineWidth = this.options.penWidth;
    this.ctx.lineCap = 'round';
    this.ctx.lineJoin = 'round';

    // Clear canvas with background color
    this.clear();
  }

  attachEvents() {
    // Mouse events
    this.canvas.addEventListener('mousedown', this.startDrawing.bind(this));
    this.canvas.addEventListener('mousemove', this.draw.bind(this));
    document.addEventListener('mouseup', this.stopDrawing.bind(this));

    // Touch events
    this.canvas.addEventListener('touchstart', this.handleTouchStart.bind(this));
    this.canvas.addEventListener('touchmove', this.handleTouchMove.bind(this));
    this.canvas.addEventListener('touchend', this.stopDrawing.bind(this));
  }

  startDrawing(event) {
    event.preventDefault();
    this.isDrawing = true;
    this.points = [];
    this.addPoint(this.getPointerPosition(event));
  }

  draw(event) {
    if (!this.isDrawing) return;
    event.preventDefault();
    this.addPoint(this.getPointerPosition(event));
    this.renderPoints();
  }

  stopDrawing() {
    this.isDrawing = false;
    this.points = [];
  }

  handleTouchStart(event) {
    event.preventDefault();
    if (event.touches.length === 1) {
      this.startDrawing(event.touches[0]);
    }
  }

  handleTouchMove(event) {
    event.preventDefault();
    if (event.touches.length === 1) {
      this.draw(event.touches[0]);
    }
  }

  addPoint(point) {
    this.points.push(point);
    if (this.points.length > 3) {
      const lastTwoPoints = this.points.slice(-2);
      const controlPoint = lastTwoPoints[0];
      const endPoint = {
        x: (lastTwoPoints[0].x + lastTwoPoints[1].x) / 2,
        y: (lastTwoPoints[0].y + lastTwoPoints[1].y) / 2,
      };
      this.drawCurve(controlPoint, endPoint);
      this.points = [this.points[this.points.length - 1]];
    }
  }

  drawCurve(control, end) {
    this.ctx.beginPath();
    this.ctx.moveTo(this.points[0].x, this.points[0].y);
    this.ctx.quadraticCurveTo(control.x, control.y, end.x, end.y);
    this.ctx.stroke();
    this.ctx.closePath();
  }

  renderPoints() {
    if (this.points.length < 2) return;

    this.ctx.beginPath();
    this.ctx.moveTo(this.points[0].x, this.points[0].y);

    for (let i = 1; i < this.points.length; i++) {
      this.ctx.lineTo(this.points[i].x, this.points[i].y);
    }

    this.ctx.stroke();
    this.ctx.closePath();
  }

  getPointerPosition(event) {
    const rect = this.canvas.getBoundingClientRect();
    return {
      x: event.clientX - rect.left,
      y: event.clientY - rect.top
    };
  }

  clear() {
    this.ctx.fillStyle = this.options.backgroundColor;
    this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
  }

  isEmpty() {
    const imageData = this.ctx.getImageData(
      0, 0,
      this.canvas.width,
      this.canvas.height
    ).data;

    return !imageData.some(channel => channel !== 0);
  }

  toDataURL(type = 'image/png', quality = 1) {
    return this.canvas.toDataURL(type, quality);
  }

  fromDataURL(dataUrl) {
    const image = new Image();
    image.src = dataUrl;
    image.onload = () => {
      this.ctx.drawImage(image, 0, 0);
    };
  }
}

export default SignaturePad; 