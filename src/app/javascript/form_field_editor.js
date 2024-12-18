class FormFieldEditor {
  constructor(container, pdfViewer) {
    this.container = container;
    this.pdfViewer = pdfViewer;
    this.fields = new Map();
    this.selectedField = null;
    this.isDragging = false;
    this.dragOffset = { x: 0, y: 0 };

    this.initializeEventListeners();
  }

  initializeEventListeners() {
    // Handle field selection
    this.container.addEventListener('click', (e) => {
      const field = e.target.closest('.form-field');
      if (field) {
        this.selectField(field);
      } else {
        this.deselectField();
      }
    });

    // Handle field dragging
    this.container.addEventListener('mousedown', (e) => {
      const field = e.target.closest('.form-field');
      if (field) {
        this.startDragging(field, e);
      }
    });

    document.addEventListener('mousemove', (e) => {
      if (this.isDragging && this.selectedField) {
        this.updateDragPosition(e);
      }
    });

    document.addEventListener('mouseup', () => {
      if (this.isDragging) {
        this.stopDragging();
      }
    });
  }

  addField(type, label) {
    const field = document.createElement('div');
    field.className = 'form-field';
    field.dataset.type = type;
    field.innerHTML = `
      <div class="field-content">
        <div class="field-label">${label}</div>
        <div class="field-type">${type}</div>
      </div>
      <div class="field-resize-handle"></div>
    `;

    const id = `field-${Date.now()}`;
    field.id = id;
    this.fields.set(id, {
      type,
      label,
      position: { x: 0, y: 0 },
      size: { width: 100, height: 30 }
    });

    this.container.appendChild(field);
    this.updateFieldPosition(field);
    return field;
  }

  selectField(field) {
    if (this.selectedField) {
      this.selectedField.classList.remove('selected');
    }
    field.classList.add('selected');
    this.selectedField = field;
    this.triggerFieldSelected(field);
  }

  deselectField() {
    if (this.selectedField) {
      this.selectedField.classList.remove('selected');
      this.selectedField = null;
      this.triggerFieldDeselected();
    }
  }

  startDragging(field, event) {
    this.isDragging = true;
    this.selectField(field);
    const rect = field.getBoundingClientRect();
    this.dragOffset = {
      x: event.clientX - rect.left,
      y: event.clientY - rect.top
    };
    field.classList.add('dragging');
  }

  updateDragPosition(event) {
    const containerRect = this.container.getBoundingClientRect();
    const x = event.clientX - containerRect.left - this.dragOffset.x;
    const y = event.clientY - containerRect.top - this.dragOffset.y;

    const field = this.selectedField;
    const fieldData = this.fields.get(field.id);
    fieldData.position = { x, y };
    this.updateFieldPosition(field);
  }

  stopDragging() {
    this.isDragging = false;
    if (this.selectedField) {
      this.selectedField.classList.remove('dragging');
      this.triggerFieldMoved(this.selectedField);
    }
  }

  updateFieldPosition(field) {
    const fieldData = this.fields.get(field.id);
    field.style.transform = `translate(${fieldData.position.x}px, ${fieldData.position.y}px)`;
  }

  getFieldData(field) {
    return this.fields.get(field.id);
  }

  // Event triggers
  triggerFieldSelected(field) {
    const event = new CustomEvent('field:selected', {
      detail: { field, data: this.getFieldData(field) }
    });
    this.container.dispatchEvent(event);
  }

  triggerFieldDeselected() {
    const event = new CustomEvent('field:deselected');
    this.container.dispatchEvent(event);
  }

  triggerFieldMoved(field) {
    const event = new CustomEvent('field:moved', {
      detail: { field, data: this.getFieldData(field) }
    });
    this.container.dispatchEvent(event);
  }
}

export default FormFieldEditor; 