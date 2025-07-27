<!DOCTYPE html>
<html>
<head>
    <title>Uploaded Images</title>
</head>
<body>
    <h1>Uploaded Images</h1>

    @if (session('success'))
        <p style="color: green;">{{ session('success') }}</p>
    @endif

    <a href="{{ route('images.create') }}">Upload New Image</a>

    @foreach ($images as $image)
        <div style="margin-bottom: 20px;">
            <h3>{{ $image->title }}</h3>
            <p>{{ $image->description }}</p>
            <img src="{{ asset('storage/' . $image->image_path) }}" width="300">
        </div>
    @endforeach
</body>
</html>
