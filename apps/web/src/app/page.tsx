export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center">
      <div className="text-center">
        <h1 className="text-4xl font-bold mb-4">LEGIMI COMMERCE</h1>
        <p className="text-xl text-gray-600">
          AI-native commerce operating system
        </p>
        <div className="mt-8 space-x-4">
          <button className="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
            Dashboard
          </button>
          <button className="px-6 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">
            Docs
          </button>
        </div>
      </div>
    </main>
  )
}
