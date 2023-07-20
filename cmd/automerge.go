package cmd

import (
	_ "embed"
	"fmt"
	"io"
	"os"

	"github.com/spf13/cobra"
)

// Print version and commit ID as json blob
var automerge bool = true

// var automerge bool = false

func init() {
	rootCmd.AddCommand(NewAutomergeCmd())
}

func NewAutomergeCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "automerge",
		Short: "print true for automerge",
		Args:  cobra.NoArgs,
		RunE: func(cmd *cobra.Command, args []string) error {
			return runAutomerge(os.Stdout)
		},
	}
	return cmd
}

func runAutomerge(out io.Writer) error {
	fmt.Fprint(out, automerge)
	return nil
}
