# capacitor-plugin-video-editor

Capacitor plugin to edit videos

## Install

```bash
npm install @whiteguru/capacitor-plugin-video-editor
npx cap sync
```

### or for Capacitor 3.x

```bash
pm install @whiteguru/capacitor-plugin-video-editor@3.0.1
npx cap sync
```

## API

<docgen-index>

* [`edit(...)`](#edit)
* [`thumbnail(...)`](#thumbnail)
* [`addListener('transcodeProgress', ...)`](#addlistenertranscodeprogress)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### edit(...)

```typescript
edit(options: EditOptions) => Promise<MediaFileResult>
```

| Param         | Type                                                |
| ------------- | --------------------------------------------------- |
| **`options`** | <code><a href="#editoptions">EditOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#mediafileresult">MediaFileResult</a>&gt;</code>

--------------------


### thumbnail(...)

```typescript
thumbnail(options: ThumbnailOptions) => Promise<MediaFileResult>
```

| Param         | Type                                                          |
| ------------- | ------------------------------------------------------------- |
| **`options`** | <code><a href="#thumbnailoptions">ThumbnailOptions</a></code> |

**Returns:** <code>Promise&lt;<a href="#mediafileresult">MediaFileResult</a>&gt;</code>

--------------------


### addListener('transcodeProgress', ...)

```typescript
addListener(eventName: 'transcodeProgress', listenerFunc: (info: ProgressInfo) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

| Param              | Type                                                                     |
| ------------------ | ------------------------------------------------------------------------ |
| **`eventName`**    | <code>'transcodeProgress'</code>                                         |
| **`listenerFunc`** | <code>(info: <a href="#progressinfo">ProgressInfo</a>) =&gt; void</code> |

**Returns:** <code>Promise&lt;<a href="#pluginlistenerhandle">PluginListenerHandle</a>&gt; & <a href="#pluginlistenerhandle">PluginListenerHandle</a></code>

--------------------


### Interfaces


#### MediaFileResult

| Prop       | Type                                            |
| ---------- | ----------------------------------------------- |
| **`file`** | <code><a href="#mediafile">MediaFile</a></code> |


#### MediaFile

| Prop       | Type                | Description                                     |
| ---------- | ------------------- | ----------------------------------------------- |
| **`name`** | <code>string</code> | The name of the file, without path information. |
| **`path`** | <code>string</code> | The full path of the file, including the name.  |
| **`type`** | <code>string</code> | The file's mime type                            |
| **`size`** | <code>number</code> | The size of the file, in bytes.                 |


#### EditOptions

| Prop            | Type                                                          |
| --------------- | ------------------------------------------------------------- |
| **`path`**      | <code>string</code>                                           |
| **`trim`**      | <code><a href="#trimoptions">TrimOptions</a></code>           |
| **`transcode`** | <code><a href="#transcodeoptions">TranscodeOptions</a></code> |
| **`overlay`**   | <code><a href="#overlayoptions">OverlayOptions</a></code>     |


#### TrimOptions

| Prop           | Type                | Description              |
| -------------- | ------------------- | ------------------------ |
| **`startsAt`** | <code>number</code> | StartsAt in milliseconds |
| **`endsAt`**   | <code>number</code> | EndsAt in milliseconds   |


#### TranscodeOptions

| Prop                  | Type                 |
| --------------------- | -------------------- |
| **`height`**          | <code>number</code>  |
| **`width`**           | <code>number</code>  |
| **`keepAspectRatio`** | <code>boolean</code> |


#### OverlayOptions

| Prop                  | Type                 |
| --------------------- | -------------------- |
| **`path`**            | <code>string</code>  |
| **`top`**             | <code>number</code>  |
| **`left`**            | <code>number</code>  |
| **`height`**          | <code>number</code>  |
| **`width`**           | <code>number</code>  |
| **`keepAspectRatio`** | <code>boolean</code> |


#### ThumbnailOptions

| Prop         | Type                | Description                                                          |
| ------------ | ------------------- | -------------------------------------------------------------------- |
| **`path`**   | <code>string</code> |                                                                      |
| **`at`**     | <code>number</code> | The time position where the frame will be retrieved in milliseconds. |
| **`width`**  | <code>number</code> |                                                                      |
| **`height`** | <code>number</code> |                                                                      |


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |


#### ProgressInfo

| Prop           | Type                |
| -------------- | ------------------- |
| **`progress`** | <code>number</code> |

</docgen-api>
