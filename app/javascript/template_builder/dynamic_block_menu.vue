<template>
  <div
    class="absolute z-[5] pointer-events-none select-none"
    :style="{ top: coords.top + 'px', left: coords.left + 'px', width: coords.width + 'px', height: coords.height + 'px' }"
  >
    <div
      class="absolute left-0 flex items-center gap-0.5 p-1 bg-white border border-neutral-200 rounded-lg shadow-lg pointer-events-auto"
      :style="{ top: Math.max(coords.top - 40, 0) - coords.top + 'px' }"
      @mousedown.prevent
    >
      <button
        v-for="(icon, align) in alignIcons"
        :key="align"
        class="inline-flex items-center justify-center w-7 h-7 rounded-md hover:bg-neutral-100"
        :class="{ 'bg-neutral-200': coords.align === align }"
        :title="t(`align_${align}`)"
        @click="$emit('command', 'setBlockAlign', align)"
      >
        <component
          :is="icon"
          :width="16"
          :height="16"
          :stroke-width="1.6"
        />
      </button>
      <div class="w-px h-5 bg-neutral-200 mx-1" />
      <template v-if="coords.type === 'table'">
        <button
          v-for="action in tableActions"
          :key="action.title"
          class="inline-flex items-center justify-center w-7 h-7 rounded-md"
          :class="[{ 'text-red-600': action.danger }, isDisabled(action) ? 'opacity-50 cursor-not-allowed' : 'hover:bg-neutral-100']"
          :title="action.structural && !coords.isRegular ? t('irregular_table_structure') : t(action.title)"
          :disabled="isDisabled(action)"
          @click="$emit('command', action.command, action.arg)"
        >
          <component
            :is="action.icon"
            :width="16"
            :height="16"
            :stroke-width="1.6"
          />
        </button>
      </template>
      <button
        v-else
        class="inline-flex items-center justify-center w-7 h-7 rounded-md hover:bg-neutral-100 text-red-600"
        :title="t('delete_image')"
        @click="$emit('command', 'deleteSelection')"
      >
        <IconTrash
          :width="16"
          :height="16"
          :stroke-width="1.6"
        />
      </button>
    </div>
    <div
      v-if="size && coords.type === 'table'"
      class="absolute top-0 left-0 border border-dashed border-blue-500"
      :style="{ width: size.width + 'px', height: size.height + 'px' }"
    />
    <div
      v-if="coords.type === 'table'"
      class="absolute w-3 h-3 bg-white border-2 border-blue-500 rounded-sm pointer-events-auto cursor-nwse-resize"
      :style="{ left: (size?.width ?? coords.width) - 6 + 'px', top: (size?.height ?? coords.height) - 6 + 'px' }"
      :title="t('resize')"
      @mousedown.prevent.stop="startResize"
    />
  </div>
</template>

<script>
import { h } from 'vue'
import { IconAlignLeft, IconAlignCenter, IconAlignRight, IconRowInsertTop, IconRowInsertBottom, IconColumnInsertLeft, IconColumnInsertRight, IconRowRemove, IconColumnRemove, IconTrash } from '@tabler/icons-vue'

const IconMergeCells = (props) => h('svg', { xmlns: 'http://www.w3.org/2000/svg', viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-linecap': 'round', 'stroke-linejoin': 'round', ...props }, [
  h('path', { d: 'M5 4h14a2 2 0 0 1 2 2v12a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2v-12a2 2 0 0 1 2 -2z' }),
  h('path', { d: 'M6 12h4m-2 -2l2 2l-2 2' }),
  h('path', { d: 'M18 12h-4m2 -2l-2 2l2 2' })
])

const IconSplitCell = (props) => h('svg', { xmlns: 'http://www.w3.org/2000/svg', viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-linecap': 'round', 'stroke-linejoin': 'round', ...props }, [
  h('path', { d: 'M5 4h14a2 2 0 0 1 2 2v12a2 2 0 0 1 -2 2h-14a2 2 0 0 1 -2 -2v-12a2 2 0 0 1 2 -2z' }),
  h('path', { d: 'M12 4v16' }),
  h('path', { d: 'M10 12h-4m2 -2l-2 2l2 2' }),
  h('path', { d: 'M14 12h4m-2 -2l2 2l-2 2' })
])

export default {
  name: 'DynamicBlockMenu',
  components: {
    IconTrash
  },
  inject: ['t'],
  props: {
    coords: {
      type: Object,
      required: true
    }
  },
  emits: ['command', 'resize'],
  data () {
    return {
      size: null
    }
  },
  computed: {
    alignIcons () {
      return {
        left: IconAlignLeft,
        center: IconAlignCenter,
        right: IconAlignRight
      }
    },
    tableActions () {
      return [
        { command: 'addTableRow', arg: false, icon: IconRowInsertTop, title: 'insert_row_above', structural: true },
        { command: 'addTableRow', arg: true, icon: IconRowInsertBottom, title: 'insert_row_below', structural: true },
        { command: 'addTableColumn', arg: false, icon: IconColumnInsertLeft, title: 'insert_column_left', structural: true },
        { command: 'addTableColumn', arg: true, icon: IconColumnInsertRight, title: 'insert_column_right', structural: true },
        { command: 'mergeTableCells', icon: IconMergeCells, title: 'merge_cells', structural: true, enabled: 'canMerge' },
        { command: 'splitTableCell', icon: IconSplitCell, title: 'split_cell', structural: true, enabled: 'canSplit' },
        { command: 'deleteTableRow', icon: IconRowRemove, title: 'delete_row', danger: true, structural: true },
        { command: 'deleteTableColumn', icon: IconColumnRemove, title: 'delete_column', danger: true, structural: true },
        { command: 'deleteTable', icon: IconTrash, title: 'delete_table', danger: true }
      ]
    }
  },
  beforeUnmount () {
    window.removeEventListener('mousemove', this.onResizeMove)
    window.removeEventListener('mouseup', this.onResizeEnd)
  },
  methods: {
    isDisabled (action) {
      return (action.structural && !this.coords.isRegular) || (action.enabled && !this.coords[action.enabled])
    },
    startResize (event) {
      this.resizeStart = { x: event.clientX, y: event.clientY, width: this.coords.width, height: this.coords.height }
      this.size = { width: this.coords.width, height: this.coords.height }

      window.addEventListener('mousemove', this.onResizeMove)
      window.addEventListener('mouseup', this.onResizeEnd)
    },
    onResizeMove (event) {
      const { x, y, width, height } = this.resizeStart
      this.size = {
        width: Math.max(width + event.clientX - x, 20),
        height: Math.max(height + event.clientY - y, this.coords.minHeight)
      }
    },
    onResizeEnd () {
      window.removeEventListener('mousemove', this.onResizeMove)
      window.removeEventListener('mouseup', this.onResizeEnd)

      if (this.size.width !== this.coords.width || this.size.height !== this.coords.height) {
        this.$emit('resize', this.size)
      }

      this.size = null
    }
  }
}
</script>
