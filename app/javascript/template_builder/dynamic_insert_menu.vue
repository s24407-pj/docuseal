<template>
  <div
    class="absolute z-10 select-none text-sm"
    :style="{ top: coords.top - 12 + 'px', left: coords.left - 12 + 'px' }"
    @mousedown.prevent
  >
    <button
      class="flex items-center justify-center w-6 h-6 rounded-md border border-neutral-200"
      :class="isOpen ? 'bg-neutral-100 text-base-content' : 'bg-white text-base-content/40 hover:bg-neutral-100 hover:text-base-content'"
      :title="t('insert')"
      @click="isOpen = !isOpen"
    >
      <IconX
        v-if="isOpen"
        :width="14"
        :height="14"
      />
      <IconPlus
        v-else
        :width="14"
        :height="14"
      />
    </button>
    <div
      v-if="isOpen"
      class="absolute top-7 left-0 min-w-36 p-1 bg-white border border-neutral-200 rounded-lg shadow-lg"
    >
      <div
        class="relative"
        @mouseenter="submenu = 'field'"
      >
        <button
          class="flex items-center gap-2 w-full px-2 py-1 rounded-md"
          :class="{ 'bg-neutral-100': submenu === 'field' }"
        >
          <IconForms
            :width="16"
            :height="16"
            :stroke-width="1.6"
          />
          {{ t('field') }}
          <IconChevronRight
            :width="14"
            :height="14"
            class="ml-auto"
          />
        </button>
        <div
          v-if="submenu === 'field'"
          class="absolute top-0 left-full min-w-40 p-1 bg-white border border-neutral-200 rounded-lg shadow-lg"
        >
          <button
            v-for="(icon, type) in fieldTypesList"
            :key="type"
            class="flex items-center gap-2 w-full px-2 py-1 rounded-md hover:bg-neutral-100"
            @click="[$emit('insert-field', type), isOpen = false]"
          >
            <component
              :is="icon"
              :width="16"
              :height="16"
              :stroke-width="1.6"
            />
            {{ fieldNames[type] }}
          </button>
        </div>
      </div>
      <div
        class="relative"
        @mouseenter="submenu = 'table'"
      >
        <button
          class="flex items-center gap-2 w-full px-2 py-1 rounded-md"
          :class="{ 'bg-neutral-100': submenu === 'table' }"
        >
          <IconTable
            :width="16"
            :height="16"
            :stroke-width="1.6"
          />
          {{ t('table') }}
          <IconChevronRight
            :width="14"
            :height="14"
            class="ml-auto"
          />
        </button>
        <div
          v-if="submenu === 'table'"
          class="absolute top-0 left-full w-max p-2 bg-white border border-neutral-200 rounded-lg shadow-lg"
          @mouseleave="tableSize = { rows: 0, cols: 0 }"
        >
          <div class="grid grid-cols-8 gap-0.5">
            <template
              v-for="row in 8"
              :key="row"
            >
              <button
                v-for="col in 8"
                :key="col"
                class="w-4 h-4 border rounded-sm"
                :class="row <= tableSize.rows && col <= tableSize.cols ? 'bg-neutral-200 border-neutral-400' : 'bg-white border-neutral-200'"
                @mouseenter="tableSize = { rows: row, cols: col }"
                @click="[$emit('insert-table', { rows: row, cols: col }), isOpen = false]"
              />
            </template>
          </div>
          <div class="mt-1 text-xs text-center text-base-content/60">
            {{ tableSize.rows ? `${tableSize.rows} × ${tableSize.cols}` : t('table_size') }}
          </div>
        </div>
      </div>
      <button
        class="flex items-center gap-2 w-full px-2 py-1 rounded-md hover:bg-neutral-100"
        @mouseenter="submenu = null"
        @click="[$emit('insert-variable'), isOpen = false]"
      >
        <IconBracketsContain
          :width="16"
          :height="16"
          :stroke-width="1.6"
        />
        {{ t('variable') }}
      </button>
      <button
        class="flex items-center gap-2 w-full px-2 py-1 rounded-md hover:bg-neutral-100"
        @mouseenter="submenu = null"
        @click="[$emit('insert-image'), isOpen = false]"
      >
        <IconPhoto
          :width="16"
          :height="16"
          :stroke-width="1.6"
        />
        {{ t('image') }}
      </button>
    </div>
  </div>
</template>

<script>
import { IconPlus, IconX, IconForms, IconTable, IconPhoto, IconChevronRight, IconBracketsContain } from '@tabler/icons-vue'
import FieldType from './field_type.vue'

export default {
  name: 'DynamicInsertMenu',
  components: {
    IconPlus,
    IconX,
    IconForms,
    IconTable,
    IconPhoto,
    IconChevronRight,
    IconBracketsContain
  },
  inject: ['withPhone', 'withPayment', 'withVerification', 'withKba', 't', 'fieldTypes'],
  props: {
    coords: {
      type: Object,
      required: true
    }
  },
  emits: ['insert-field', 'insert-table', 'insert-variable', 'insert-image'],
  data () {
    return {
      isOpen: false,
      submenu: null,
      tableSize: { rows: 0, cols: 0 }
    }
  },
  computed: {
    fieldNames: FieldType.computed.fieldNames,
    fieldIcons: FieldType.computed.fieldIcons,
    skipTypes: FieldType.computed.skipTypes,
    fieldIconsSorted: FieldType.computed.fieldIconsSorted,
    fieldTypesList () {
      return Object.fromEntries(Object.entries(this.fieldIconsSorted).filter(([type]) => {
        return this.fieldTypes.includes(type) || ((this.withPhone || type !== 'phone') && (this.withPayment || type !== 'payment') && (this.withVerification || type !== 'verification') && (this.withKba || type !== 'kba'))
      }))
    }
  },
  watch: {
    isOpen (value) {
      this.submenu = null

      if (value) {
        document.addEventListener('mousedown', this.onDocumentMouseDown)
      } else {
        document.removeEventListener('mousedown', this.onDocumentMouseDown)
      }
    }
  },
  beforeUnmount () {
    document.removeEventListener('mousedown', this.onDocumentMouseDown)
  },
  methods: {
    onDocumentMouseDown (event) {
      if (!event.composedPath().includes(this.$el)) {
        this.isOpen = false
      }
    }
  }
}
</script>
