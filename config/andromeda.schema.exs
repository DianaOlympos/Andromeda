@moduledoc """
A schema is a keyword list which represents how to map, transform, and validate
configuration values parsed from the .conf file. The following is an explanation of
each key in the schema definition in order of appearance, and how to use them.

## Import

A list of application names (as atoms), which represent apps to load modules from
which you can then reference in your schema definition. This is how you import your
own custom Validator/Transform modules, or general utility modules for use in
validator/transform functions in the schema. For example, if you have an application
`:foo` which contains a custom Transform module, you would add it to your schema like so:

`[ import: [:foo], ..., transforms: ["myapp.some.setting": MyApp.SomeTransform]]`

## Extends

A list of application names (as atoms), which contain schemas that you want to extend
with this schema. By extending a schema, you effectively re-use definitions in the
extended schema. You may also override definitions from the extended schema by redefining them
in the extending schema. You use `:extends` like so:

`[ extends: [:foo], ... ]`

## Mappings

Mappings define how to interpret settings in the .conf when they are translated to
runtime configuration. They also define how the .conf will be generated, things like
documention, @see references, example values, etc.

See the moduledoc for `Conform.Schema.Mapping` for more details.

## Transforms

Transforms are custom functions which are executed to build the value which will be
stored at the path defined by the key. Transforms have access to the current config
state via the `Conform.Conf` module, and can use that to build complex configuration
from a combination of other config values.

See the moduledoc for `Conform.Schema.Transform` for more details and examples.

## Validators

Validators are simple functions which take two arguments, the value to be validated,
and arguments provided to the validator (used only by custom validators). A validator
checks the value, and returns `:ok` if it is valid, `{:warn, message}` if it is valid,
but should be brought to the users attention, or `{:error, message}` if it is invalid.

See the moduledoc for `Conform.Schema.Validator` for more details and examples.
"""
[
  extends: [],
  import: [],
  mappings: [
    "logger.console.format": [
      commented: false,
      datatype: :binary,
      default: """
      $time $metadata[$level] $message
      """,
      doc: "Provide documentation for logger.console.format here.",
      hidden: false,
      to: "logger.console.format"
    ],
    "logger.console.metadata": [
      commented: false,
      datatype: [
        list: :atom
      ],
      default: [
        :request_id
      ],
      doc: "Provide documentation for logger.console.metadata here.",
      hidden: false,
      to: "logger.console.metadata"
    ],
    "logger.level": [
      commented: false,
      datatype: :atom,
      default: :info,
      doc: "Provide documentation for logger.level here.",
      hidden: false,
      to: "logger.level"
    ],
    "andromeda.Elixir.Andromeda.Endpoint.root": [
      commented: false,
      datatype: :binary,
      default: "/home/odiana/dev/Rommie/andromeda",
      doc: "Provide documentation for andromeda.Elixir.Andromeda.Endpoint.root here.",
      hidden: false,
      to: "andromeda.Elixir.Andromeda.Endpoint.root"
    ],
    "andromeda.Elixir.Andromeda.Endpoint.render_errors.accepts": [
      commented: false,
      datatype: [
        list: :binary
      ],
      default: [
        "html",
        "json"
      ],
      doc: "Provide documentation for andromeda.Elixir.Andromeda.Endpoint.render_errors.accepts here.",
      hidden: false,
      to: "andromeda.Elixir.Andromeda.Endpoint.render_errors.accepts"
    ],
    "andromeda.Elixir.Andromeda.Endpoint.pubsub.name": [
      commented: false,
      datatype: :atom,
      default: Andromeda.PubSub,
      doc: "Provide documentation for andromeda.Elixir.Andromeda.Endpoint.pubsub.name here.",
      hidden: false,
      to: "andromeda.Elixir.Andromeda.Endpoint.pubsub.name"
    ],
    "andromeda.Elixir.Andromeda.Endpoint.pubsub.adapter": [
      commented: false,
      datatype: :atom,
      default: Phoenix.PubSub.PG2,
      doc: "Provide documentation for andromeda.Elixir.Andromeda.Endpoint.pubsub.adapter here.",
      hidden: false,
      to: "andromeda.Elixir.Andromeda.Endpoint.pubsub.adapter"
    ],
    "andromeda.Elixir.Andromeda.Endpoint.http.port": [
      commented: false,
      datatype: :integer,
      default: 8888,
      doc: "Provide documentation for andromeda.Elixir.Andromeda.Endpoint.http.port here.",
      hidden: false,
      to: "andromeda.Elixir.Andromeda.Endpoint.http.port"
    ],
    "andromeda.Elixir.Andromeda.Endpoint.url.host": [
      commented: false,
      datatype: :binary,
      default: "rommie.space",
      doc: "Provide documentation for andromeda.Elixir.Andromeda.Endpoint.url.host here.",
      hidden: false,
      to: "andromeda.Elixir.Andromeda.Endpoint.url.host"
    ],
    "andromeda.Elixir.Andromeda.Endpoint.cache_static_manifest": [
      commented: false,
      datatype: :binary,
      default: "priv/static/manifest.json",
      doc: "Provide documentation for andromeda.Elixir.Andromeda.Endpoint.cache_static_manifest here.",
      hidden: false,
      to: "andromeda.Elixir.Andromeda.Endpoint.cache_static_manifest"
    ],
    "andromeda.Elixir.Andromeda.Endpoint.server": [
      commented: false,
      datatype: :atom,
      default: true,
      doc: "Provide documentation for andromeda.Elixir.Andromeda.Endpoint.server here.",
      hidden: false,
      to: "andromeda.Elixir.Andromeda.Endpoint.server"
    ],
    "andromeda.Elixir.Andromeda.Endpoint.secret_key_base": [
      commented: false,
      datatype: :binary,
      default: "IUk8fPtMoXPT/5hlkgJGkgUyJi8wnipPEs4G8VNqqvV0jrHLRjoXGvjFfHhd7rj",
      doc: "Provide documentation for andromeda.Elixir.Andromeda.Endpoint.secret_key_base here.",
      hidden: false,
      to: "andromeda.Elixir.Andromeda.Endpoint.secret_key_base"
    ],
    "andromeda.client_id": [
      commented: false,
      datatype: :binary,
      doc: "Provide documentation for andromeda.client_id here.",
      hidden: false,
      to: "andromeda.client_id"
    ],
    "andromeda.client_secret": [
      commented: false,
      datatype: :binary,
      doc: "Provide documentation for andromeda.client_secret here.",
      hidden: false,
      to: "andromeda.client_secret"
    ],
    "andromeda.redirect_uri": [
      commented: false,
      datatype: :binary,
      doc: "Provide documentation for andromeda.redirect_uri here.",
      hidden: false,
      to: "andromeda.redirect_uri"
    ],
    "andromeda.scope": [
      commented: false,
      datatype: :binary,
      default: "characterLocationRead characterNavigationWrite",
      doc: "Provide documentation for andromeda.scope here.",
      hidden: false,
      to: "andromeda.scope"
    ],
    "andromeda.user_agent": [
      commented: false,
      datatype: :binary,
      doc: "Provide documentation for andromeda.user_agent here.",
      hidden: false,
      to: "andromeda.user_agent"
    ],
    "guardian.Elixir.Guardian.issuer": [
      commented: false,
      datatype: :binary,
      default: "Andromeda",
      doc: "Provide documentation for guardian.Elixir.Guardian.issuer here.",
      hidden: false,
      to: "guardian.Elixir.Guardian.issuer"
    ],
    "guardian.Elixir.Guardian.ttl": [
      commented: false,
      datatype: {:atom, :atom},
      default: {20, :hours},
      doc: "Provide documentation for guardian.Elixir.Guardian.ttl here.",
      hidden: false,
      to: "guardian.Elixir.Guardian.ttl"
    ],
    "guardian.Elixir.Guardian.verify_issuer": [
      commented: false,
      datatype: :atom,
      default: true,
      doc: "Provide documentation for guardian.Elixir.Guardian.verify_issuer here.",
      hidden: false,
      to: "guardian.Elixir.Guardian.verify_issuer"
    ],
    "guardian.Elixir.Guardian.secret_key": [
      commented: false,
      datatype: :binary,
      default: "PWRDjzEkJdw48BsgdNyzHGF6Atvb6HCtxLj95aDU",
      doc: "Provide documentation for guardian.Elixir.Guardian.secret_key here.",
      hidden: false,
      to: "guardian.Elixir.Guardian.secret_key"
    ],
    "guardian.Elixir.Guardian.serializer": [
      commented: false,
      datatype: :atom,
      default: Andromeda.GuardianSerializer,
      doc: "Provide documentation for guardian.Elixir.Guardian.serializer here.",
      hidden: false,
      to: "guardian.Elixir.Guardian.serializer"
    ],
    "guardian.Elixir.Guardian.verify_module": [
      commented: false,
      datatype: :atom,
      default: Andromeda.GuardianVerifier,
      doc: "Provide documentation for guardian.Elixir.Guardian.verify_module here.",
      hidden: false,
      to: "guardian.Elixir.Guardian.verify_module"
    ],
    "phoenix.generators.migration": [
      commented: false,
      datatype: :atom,
      default: false,
      doc: "Provide documentation for phoenix.generators.migration here.",
      hidden: false,
      to: "phoenix.generators.migration"
    ],
    "phoenix.generators.binary_id": [
      commented: false,
      datatype: :atom,
      default: false,
      doc: "Provide documentation for phoenix.generators.binary_id here.",
      hidden: false,
      to: "phoenix.generators.binary_id"
    ]
  ],
  transforms: [],
  validators: []
]